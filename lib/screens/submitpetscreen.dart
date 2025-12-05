// ignore_for_file: file_names
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../myconfig.dart';
import '../models/user.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;
  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  List<String> petTypes = ['Cat', 'Dog', 'Rabbit', 'Other'];
  List<String> categories = ['Adoption', 'Donation Request', 'Help/Rescue'];
  String selectedPetType = 'Cat';
  String selectedCategory = 'Adoption';
  late double screenWidth, screenHeight;
  late Position mypostion;
  List<File> images = [];
  List<Uint8List> webImages = [];
  TextEditingController petNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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
      appBar: AppBar(title: Text('Submit Pet Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: screenWidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight / 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // image picker containers
                        children: [
                          for (int index = 0; index <= 2; index++)
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  kIsWeb ? openGallery() : pickimagedialog();
                                },
                                child: Container(
                                  width: screenWidth * 0.7,
                                  height: screenHeight / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 2,
                                    ),
                                    image: (images.length > index && !kIsWeb)
                                        ? DecorationImage(
                                            image: FileImage(images[index]),
                                            fit: BoxFit.cover,
                                          )
                                        : (webImages.length > index)
                                        ? DecorationImage(
                                            image: MemoryImage(
                                              webImages[index],
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: // show icon if no image selected
                                      (images.length <= index &&
                                          webImages.length <= index)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Tap to add image",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // pet name text field
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  // pet type dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Pet Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petTypes.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPetType = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // submission category dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Submission Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: categories.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    // description text field
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 10),
                  // location text field with autofill button
                  Row(
                    children: [
                      Flexible(
                        flex: 4,
                        child: TextFormField(
                          controller: locationController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Location (Lat, Lng)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(55, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.deepOrange,
                              width: 2,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // show loading dialog while fetching location
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text('Fetching Location...'),
                                  ],
                                ),
                              );
                            },
                          );
                          try {
                            // error handling for _getLocation
                            mypostion = await _getLocation();
                            if (!context.mounted) return;
                            Navigator.pop(context); // close the loading dialog
                            setState(() {
                              locationController.text =
                                  'Lat: ${mypostion.latitude}, Lng: ${mypostion.longitude}';
                            });
                          } catch (e) {
                            if (!context.mounted) return;
                            Navigator.pop(context); // close the loading dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error fetching location: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text('Auto\n Fill'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // submit button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(screenWidth, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showSubmitDialog();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSubmitDialog() {
    if (petNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter pet name"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!kIsWeb && images.isEmpty) {
      // image vaidation for mobile
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (kIsWeb && webImages.isEmpty) {
      // image validation for web
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pet Submission Confirmation'),
          content: Text('Are you sure you want to submit this pet?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitPet();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void submitPet() {
    List<String> base64image = [];
    if (kIsWeb) {
      for (var bytes in webImages) {
        base64image.add(base64Encode(bytes));
      }
    } else {
      for (var file in images) {
        base64image.add(base64Encode(file.readAsBytesSync()));
      }
    }
    String petName = petNameController.text.trim();
    String description = descriptionController.text.trim();
    String lat = "0.0";
    String lng = "0.0";
    try {
      lat = mypostion.latitude.toString();
      lng = mypostion.longitude.toString();
    } catch (e) {
      // User didn't click auto-fill, ignore error
    }
    Map<String, String> body = {
      'user_id': widget.user?.userId ?? '0',
      'pet_name': petName,
      'pet_type': selectedPetType,
      'category': selectedCategory,
      'description': description,
      'lat': lat,
      'lng': lng,
    };
    for (int i = 0; i < base64image.length; i++) {
      body['image_paths[$i]'] = base64image[i];
    }

    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php'),
          body: body,
        )
        .then((response) {
          if (response.statusCode == 200) {
            log("Submit Pet Log: ${response.body}");
            var resarray = jsonDecode(response.body);
            if (resarray['success'] == true) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
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
        webImages.add(await pickedFile.readAsBytes());
        setState(() {});
      } else {
        images.add(File(pickedFile.path)); // only mobile
        setState(() {});
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        webImages.add(await pickedFile.readAsBytes());
        setState(() {});
      } else {
        images.add(File(pickedFile.path)); // only mobile
        setState(() {});
      }
    }
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
