import 'package:flutter/material.dart';
import 'package:pawpal_pet_adoption/views/loginpage.dart';
import 'package:pawpal_pet_adoption/models/user.dart';

class MainPage extends StatefulWidget {
  final User? user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String status = "";

  @override
  void initState() {
    super.initState();
    status = "Hi, ${widget.user?.name ?? 'Guest'}! Welcome to PawPal!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: const Color(0xFFA66A46), 
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.login, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFCE9D9),
              Color(0xFFF5D7C2),
              Color(0xFFE9BFA7),
            ],
          ),
        ),
        child: Center(
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5E3C), 
            ),
          ),
        ),
      ),
    );
  }
}
