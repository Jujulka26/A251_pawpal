import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/shared/mydrawer.dart';
import 'package:pawpal/models/donation.dart';

class DonationHistoryScreen extends StatefulWidget {
  final User? user;
  const DonationHistoryScreen({super.key, required this.user});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  late double screenWidth, screenHeight;
  List<Donation> donationList = [];
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadDonationHistory();
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
        title: const Text('My Donations'),
        actions: [
          IconButton(
            onPressed: () {
              loadDonationHistory();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
      body: Column(
        children: [
          donationList.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.find_in_page_outlined, size: 64),
                        SizedBox(height: 12),
                        Text(
                          status,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: donationList.length,
                    itemBuilder: (context, index) {
                      final donation = donationList[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 75,
                              decoration: BoxDecoration(
                                color: getColor(donation.donationType ?? ''),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                getIcon(donation.donationType ?? ''),
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    donation.donationType ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    donation.donationType == 'Money'
                                        ? 'Amount: RM ${donation.amount}'
                                        : 'Description: ${donation.description}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pets,
                                        size: 14,
                                        color: Colors.deepOrange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        donation.petName ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(), // Pushes date to the rightmost side
                                      Text(
                                        donation.donationDate?.split(' ')[0] ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  // ================= LOAD DONATIONS =================
  void loadDonationHistory() async {
    donationList.clear();
    setState(() {
      status = "Loading...";
    });
    final response = await http.get(
      Uri.parse(
        '${MyConfig.baseUrl}/pawpal/api/get_my_donations.php?userid=${widget.user?.userId}',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        setState(() {
          donationList = (data['data'] as List)
              .map((e) => Donation.fromJson(e))
              .toList();
          status = "";
        });
      } else {
        setState(() {
          status = "No donation history found.";
        });
      }
    } else {
      setState(() {
        status = "Failed to load donation history.";
      });
    }
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'Food':
        return Icons.fastfood;
      case 'Medical':
        return Icons.medical_services;
      case 'Money':
        return Icons.attach_money;
      default:
        return Icons.volunteer_activism;
    }
  }

  Color getColor(String type) {
    switch (type) {
      case 'Food':
        return Colors.orange;
      case 'Medical':
        return Colors.red;
      case 'Money':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
