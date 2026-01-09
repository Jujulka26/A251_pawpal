import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/screens/editprofilescreen.dart';
import 'package:pawpal/shared/mydrawer.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userIdController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  late double screenWidth, screenHeight;

  void loadUserInfo() {
    userIdController.text = widget.user.userId ?? '';
    emailController.text = widget.user.email ?? '';
    nameController.text = widget.user.name ?? '';
    phoneController.text = widget.user.phone ?? '';
  }

  @override
  void initState() {
    super.initState();
    loadProfile(); // Load profile data from server
    loadUserInfo(); // Load user info into text controllers
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (screenWidth > 600) {
      screenWidth = 600;
    } else {
      screenWidth = screenWidth;
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name ?? ''), centerTitle: true),
      drawer: MyDrawer(user: widget.user),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //=================================================PROFILE AVATAR
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: Image.network(
                    '${MyConfig.baseUrl}/pawpal/api/profiles/profile_${widget.user.userId}.jpg',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        widget.user.name?.substring(0, 1).toUpperCase() ?? '',
                        style: const TextStyle(fontSize: 30),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              //==================================================UID
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.assignment_ind,
                    color: Colors.grey,
                    size: 23,
                  ),
                ),
                controller: userIdController,
                readOnly: true,
              ),
              SizedBox(height: 10),
              //====================================================PROFILE EMAIL
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.blueGrey,
                    size: 23,
                  ),
                ),
                controller: emailController,
                readOnly: true,
              ),
              SizedBox(height: 10),
              //=================================================PROFILE NAME
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.indigo,
                    size: 23,
                  ),
                ),
                controller: nameController,
                readOnly: true,
              ),
              SizedBox(height: 10),
              //=================================================PROFILE PHONE
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: Colors.green, size: 23),
                ),
                controller: phoneController,
                readOnly: true,
              ),
              //=================================================EDIT PROFILE BUTTON
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.6, 40),
                  side: BorderSide(width: 1.5, color: Colors.deepOrange),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(user: widget.user),
                    ),
                  );
                  if (result == true) {
                    loadProfile();
                  }
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadProfile() async {
    http
        .get(
          Uri.parse(
            '${MyConfig.baseUrl}/pawpal/api/get_user_profile.php?userid=${widget.user.userId}',
          ),
        )
        .then((response) {
          if (response.statusCode == 200) {
            if (!mounted) return;
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['success'] == true) {
              User user = User.fromJson(resarray['data'][0]);
              widget.user = user;
              loadUserInfo();
              setState(() {});
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
              const SnackBar(
                content: Text("Failed to load profile"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
