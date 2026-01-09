import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  User user;
  EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userIdController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  late double screenWidth, screenHeight;
  bool isLoading = false;
  File? image;
  Uint8List? webImage;

  @override
  void initState() {
    super.initState();
    loadCurrentUserInfo();
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
      appBar: AppBar(title: Text('Edit Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //=================================================PROFILE AVATAR EDIT
              GestureDetector(
                onTap: () {
                  // Handle change profile picture
                  if (kIsWeb) {
                    openGallery();
                  } else {
                    pickimagedialog();
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: ClipOval(child: _buildImagePreview()),
                ),
              ),
              SizedBox(height: 5),
              TextButton(
                child: Text(
                  'Edit Profile Picture',
                  style: TextStyle(color: Color(0xFF1976D2)),
                ),
                onPressed: () {
                  if (kIsWeb) {
                    openGallery();
                  } else {
                    pickimagedialog();
                  }
                },
              ),
              SizedBox(height: 10),
              //=================================================PROFILE USERID EDIT
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.grey, size: 23),
                  labelText: 'User ID',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: userIdController,
                readOnly: true,
              ),
              SizedBox(height: 10),
              //=================================================PROFILE EMAIL EDIT
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.grey, size: 23),
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: emailController,
                readOnly: true,
              ),
              SizedBox(height: 10),
              //=================================================PROFILE NAME EDIT
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.indigo,
                    size: 23,
                  ),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
              ),
              SizedBox(height: 10),
              //====================================================PROFILE PHONE EDIT
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: Colors.green, size: 23),
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                controller: phoneController,
              ),
              //====================================================SAVE BUTTON
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.6, 40),
                  side: BorderSide(width: 1.5, color: Colors.deepOrange),
                ),
                onPressed: () {
                  showSaveChangesDialog();
                },
                child: Text('Save Changes'),
              ),
              if (isLoading)
                SizedBox(
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void loadCurrentUserInfo() {
    userIdController.text = widget.user.userId ?? '';
    emailController.text = widget.user.email ?? '';
    nameController.text = widget.user.name ?? '';
    phoneController.text = widget.user.phone ?? '';
  }

  Widget _buildImagePreview() {
    if (image != null && !kIsWeb) {
      return Image.file(image!, fit: BoxFit.cover);
    } else if (webImage != null) {
      return Image.memory(webImage!, fit: BoxFit.cover);
    }
    return Image.network(
      '${MyConfig.baseUrl}/pawpal/api/profiles/profile_${widget.user.userId}.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Text(
            widget.user.name?.substring(0, 1).toUpperCase() ?? '',
            style: const TextStyle(fontSize: 30),
          ),
        );
      },
    );
  }

  void showSaveChangesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Save'),
          content: Text(
            'Are you sure you want to save these changes to your profile?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                editProfile();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void pickimagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path); // mobile
        setState(() {});
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path); // mobile
        setState(() {});
      }
    }
  }

  Future<void> editProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String base64image = "";
    if (kIsWeb) {
      if (webImage != null) {
        base64image = base64Encode(webImage!);
      } else {
        base64image = "NA";
      }
    } else {
      if (image != null) {
        base64image = base64Encode(image!.readAsBytesSync());
      } else {
        base64image = "NA";
      }
    }
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse('${MyConfig.baseUrl}/pawpal/api/update_profile.php'),
      body: {
        'userid': widget.user.userId,
        'name': name,
        'phone': phone,
        'image': base64image,
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating profile"),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => isLoading = false);
  }
}
