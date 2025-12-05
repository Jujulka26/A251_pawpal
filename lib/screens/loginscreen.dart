import 'dart:convert';
import 'dart:developer';
import 'package:pawpal/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'registerscreen.dart';
import 'mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late double height, width;
  bool visible = true;
  bool isChecked = false;
  late User user;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    if (width > 500) {
      width = 500;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  SizedBox(
                    height: 175,
                    width: 175,
                    child: Image.asset('assets/images/pawpal.png'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (visible) {
                            visible = false;
                          } else {
                            visible = true;
                          }
                          setState(() {});
                        },
                        icon: visible
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Remember Me'),
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          isChecked = value!;
                          setState(() {});
                          if (isChecked) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              prefUpdate(isChecked);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Preferences Stored"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please fill your email and password",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              isChecked = false;
                              setState(() {});
                            }
                          } else {
                            prefUpdate(isChecked);
                            if (emailController.text.isEmpty &&
                                passwordController.text.isEmpty) {
                              return;
                              // do nothing
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Preferences Removed"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            emailController.clear();
                            passwordController.clear();
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(300, 40),
                      side: BorderSide(width: 1, color: Colors.deepOrange),
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text('Dont have an account? Register here.'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  void loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/login_user.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {
          if (response.statusCode == 200) {
            log("Login Log: ${response.body}");
            var resarray = jsonDecode(response.body);
            if (resarray['status'] == 'success') {
              user = User.fromJson(resarray['data'][0]);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(user: user)),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
