import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfig.dart';
import 'package:pawpal/models/pet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final User user;
  final Pet pet;
  final int credits;
  const PaymentPage({
    super.key,
    required this.user,
    required this.pet,
    required this.credits,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController _webcontroller;
  late double screenHeight, screenWidth, resWidth;
  late String userName, userEmail, userPhone, userID, petID;

  @override
  void initState() {
    userEmail = widget.user.email.toString();
    userPhone = widget.user.phone.toString();
    userName = widget.user.name.toString();
    petID = widget.pet.petId.toString();
    userID = widget.user.userId.toString();

    super.initState();
    _webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          '${MyConfig.baseUrl}/pawpal/api/payment.php?email=$userEmail&phone=$userPhone&userid=$userID&name=$userName&credits=${widget.credits}&petid=$petID',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: const Color(0xFF0055FF),
      ),
      body: WebViewWidget(controller: _webcontroller),
    );
  }
}
