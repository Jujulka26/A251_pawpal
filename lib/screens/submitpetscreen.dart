// ignore_for_file: file_names
import 'dart:convert';
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
  List<String> petGenders = ['Male', 'Female'];
  List<String> petHealth = ['Healthy', 'Sick', 'Injured'];
  List<String> categories = ['Adoption', 'Donation Request', 'Help/Rescue'];
  String selectedPetType = 'Cat';
  String selectedCategory = 'Adoption';
  String selectedPetGender = 'Male';
  String selectedPetHealth = 'Healthy';
  late double screenWidth, screenHeight;
  late Position mypostion;
  List<File> images = [];
  List<Uint8List> webImages = [];
  TextEditingController petNameController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    petNameController.dispose();
    petAgeController.dispose();
    descriptionController.dispose();
    locationController.dispose();
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
      appBar: AppBar(title: Text('Submit Your Pet'), centerTitle: true),
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
                          //==============================================Image Picker Containers
                          for (int index = 0; index <= 2; index++)
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  kIsWeb ? openGallery() : pickimagedialog();
                                },
                                child: Container(
                                  width: screenWidth * 0.7,
                                  height: screenHeight / 3.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.deepOrange,
                                      width: 1.5,
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
                                              Icons
                                                  .add_photo_alternate_outlined,
                                              size: 60,
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
                  const SizedBox(height: 10),
                  //==============================================Pet Name TextField
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //==============================================Pet Type Dropdown
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
                  const SizedBox(height: 10),
                  //==============================================Pet Gender Dropdown
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Pet Gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          items: petGenders.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPetGender = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      //==============================================Pet Age TextField
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: petAgeController,
                          decoration: InputDecoration(
                            labelText: 'Pet Age (years)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //==============================================Pet Health Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Pet Health',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petHealth.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPetHealth = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  //==============================================Submission Category Dropdown
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
                  const SizedBox(height: 10),
                  //==============================================Description TextField
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  //==============================================Location TextField with Auto Fill Button
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
                      const SizedBox(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(55, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
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
                                    const SizedBox(width: 20),
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
                  const SizedBox(height: 20),
                  //==============================================Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
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

  // show confirmation dialog before submitting pet and validating inputs
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
    if (petAgeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter pet age"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (petAgeController.text.trim().contains(RegExp(r'[^\d]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pet age must be a number"),
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
          title: Text('Confirm Submission'),
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

  // submit pet to server
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
    int petAge = int.parse(petAgeController.text.trim());
    String description = descriptionController.text.trim();
    String lat = "0.0";
    String lng = "0.0";
    try {
      lat = mypostion.latitude.toString();
      lng = mypostion.longitude.toString();
    } catch (e) {
      // if location not fetched, do nothing and use default 0.0 values
    }
    Map<String, String> body = {
      'user_id': widget.user?.userId ?? '0',
      'pet_name': petName,
      'pet_type': selectedPetType,
      'pet_gender': selectedPetGender,
      'pet_age': petAge.toString(),
      'pet_health': selectedPetHealth,
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
        images.add(File(pickedFile.path)); // mobile
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
        images.add(File(pickedFile.path)); // mobile
        setState(() {});
      }
    }
  }

  Future<Position> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // Handle permission denied forever
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
