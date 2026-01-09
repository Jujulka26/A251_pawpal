import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/screens/adoptionformscreen.dart';
import 'package:pawpal/screens/donationformscreen.dart';

class PetDetailsScreen extends StatefulWidget {
  final User? user;
  final Pet? pet;
  const PetDetailsScreen({super.key, required this.user, required this.pet});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  late double screenWidth, screenHeight;

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
      appBar: AppBar(title: const Text("Pet Details"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            //================================================================PET IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${MyConfig.baseUrl}/pawpal/api/${widget.pet!.imagePaths!.split(',')[0]}",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            //================================================================PET NAME
            Text(
              widget.pet!.petName!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 20),
            //================================================================PET DESCRIPTION
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(widget.pet!.description!),
                ],
              ),
            ),
            //================================================================PET DETAILS
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              color: Colors.deepOrange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    //=======================================================PET TYPE & GENDER
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.pets,
                                size: 20,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Type: ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text("${widget.pet!.petType}"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.male,
                                size: 20,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Gender: ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text("${widget.pet!.petGender}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    //=======================================================PET AGE & HEALTH
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.cake,
                                size: 20,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Age: ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text("${widget.pet!.petAge} years"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.health_and_safety,
                                size: 20,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Health: ",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text("${widget.pet!.petHealth}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    //=======================================================POSTED BY
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.deepOrange,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Posted by: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.pet?.name}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            //============================================================ACTION BUTTONS
            Center(
              child: widget.pet!.category == "Adoption"
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(screenWidth * 0.6, 40),
                        side: BorderSide(width: 1.5, color: Colors.deepOrange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdoptionFormScreen(
                              user: widget.user,
                              pet: widget.pet,
                            ),
                          ),
                        );
                      },
                      child: const Text("Request to Adopt"),
                    )
                  : widget.pet!.category == "Donation Request"
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(screenWidth * 0.6, 40),
                        side: BorderSide(width: 1.5, color: Colors.deepOrange),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonationFormScreen(
                              user: widget.user,
                              pet: widget.pet,
                            ),
                          ),
                        );
                      },
                      child: const Text("Make a Donation"),
                    )
                  : const Text(
                      "No Action Available",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
