import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets_outlined, size: 150, color: Colors.deepOrange),
            SizedBox(height: 20),
            Text('Welcome to the Pawpal!'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hello, '),
                Text(
                  widget.user?.name ?? 'User',
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
