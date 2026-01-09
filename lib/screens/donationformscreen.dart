import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/models/pet.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/screens/paymentscreen.dart';

class DonationFormScreen extends StatefulWidget {
  final User? user;
  final Pet? pet;
  const DonationFormScreen({super.key, required this.user, required this.pet});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  String selectedDonationType = 'Money';
  List<String> donationTypes = ['Food', 'Medical', 'Money'];
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late double screenWidth, screenHeight;

  @override
  dispose() {
    amountController.dispose();
    descriptionController.dispose();
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
      appBar: AppBar(
        title: Text('Donation Form'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.clear),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //=================================================PET NAME WITH VERIFIED ICON
                  const Text(
                    'Donate for ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.pet?.petName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    size: 20,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Even the smallest donation can make a big difference.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30),
              //=================================================DONATION TYPE
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Donation Type',
                  border: OutlineInputBorder(),
                ),
                items: donationTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDonationType = newValue!;
                    amountController.clear();
                    descriptionController.clear();
                  });
                },
                initialValue: selectedDonationType,
              ),
              SizedBox(height: 20),
              //=================================================DONATION AMOUNT OR DESCRIPTION
              selectedDonationType == 'Money'
                  ? TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Donation Amount (RM)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.attach_money,
                          size: 20,
                          color: Colors.green,
                        ),
                      ),
                    )
                  : TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Donation Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.notes,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ),
              const SizedBox(height: 30),
              //=================================================SUBMIT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  minimumSize: Size(screenWidth, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  submitDonationDialog();
                },
                child: const Text(
                  'Submit Donation',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitDonationDialog() {
    if (selectedDonationType == 'Money') {
      if (amountController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter donation amount"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      double? amount = double.tryParse(amountController.text);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please enter a valid donation amount greater than 0",
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    if ((selectedDonationType == 'Food' || selectedDonationType == 'Medical') &&
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter donation description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Donation'),
          content: const Text('Are you sure you want to submit this donation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (selectedDonationType == 'Money') {
                  double rm = double.parse(amountController.text);
                  int credits = (rm * 100).round();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        user: widget.user!,
                        pet: widget.pet!,
                        credits: credits,
                      ),
                    ),
                  );
                } else {
                  submitDonation();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void submitDonation() {
    // only non-money donations reach here, hence amount is 0
    String amount = '0';
    String description = descriptionController.text;
    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_donation.php'),
          body: {
            'user_id': widget.user?.userId,
            'pet_id': widget.pet?.petId,
            'donation_type': selectedDonationType,
            'amount': amount,
            'description': description,
          },
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
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error submitting donation"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}
