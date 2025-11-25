import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_pet_adoption/myconfig.dart';
import 'package:pawpal_pet_adoption/views/loginpage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool visible = true;
  bool isLoading = false;
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    if (width > 400) {
      width = 400;
    } else {
      width = width;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
        backgroundColor: const Color(0xFFA66A46), 
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          Image.asset('assets/images/pawpal.png', scale: 1.5),
                    ),
                    const SizedBox(height: 5),

                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85),
                        labelStyle: const TextStyle(color: Color(0xFF8B5E3C)),
                        labelText: 'Email',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Name
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85),
                        labelStyle: const TextStyle(color: Color(0xFF8B5E3C)),
                        labelText: 'Name',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Phone
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85),
                        labelStyle: const TextStyle(color: Color(0xFF8B5E3C)),
                        labelText: 'Phone',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: visible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85),
                        labelStyle: const TextStyle(color: Color(0xFF8B5E3C)),
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            setState(() => visible = !visible);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Confirm Password
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: visible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.85),
                        labelStyle: const TextStyle(color: Color(0xFF8B5E3C)),
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            setState(() => visible = !visible);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFC97C5D), 
                          foregroundColor: Colors.white,
                        ),
                        onPressed: registerDialog,
                        child: const Text('Register'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      child: const Text("Already have an account? Login here",
                        style: TextStyle(color: Color(0xFF8B5E3C)), // matched
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Register Dialog
  void registerDialog() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||name.isEmpty ||phone.isEmpty ||password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (password.length < 6) {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text("Password must be at least 6 characters")),
    );
    return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    if (!RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email address")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Register this account?"),
        content: const Text("Are you sure you want to register?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              registerUser(email, password, name, phone);
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Register User
  void registerUser(
      String email, String password, String name, String phone) async {
    setState(() => isLoading = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Registering..."),
          ],
        ),
      ),
    );

   await http.post(
        Uri.parse(
            "${MyConfig.baseUrl}/pawpal_pet_adoption/api/register_user.php"),
        body: {
          "email": email,
          "name": name,
          "phone": phone,
          "password": password,  
        },
   )
          .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(jsonResponse);

            if (resarray['status'] == 'success') {
              if (!mounted) return;
              SnackBar snackBar = const SnackBar(
                content: Text('Registration successful'),
              );
              if (isLoading) {
                if (!mounted) return;
                Navigator.pop(context); // Close the loading dialog
                setState(() {
                  isLoading = false;
                });
              }
              Navigator.pop(context); // Close the registration dialog
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              if (!mounted) return;
              SnackBar snackBar = SnackBar(content: Text(resarray['message']));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Registration failed. Please try again.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .timeout(
          Duration(seconds: 10),
          onTimeout: () {
            if (!mounted) return;
            SnackBar snackBar = const SnackBar(
              content: Text('Request timed out. Please try again.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        );

    if (isLoading) {
      if (!mounted) return;
      Navigator.pop(context); // Close the loading dialog
      setState(() {
        isLoading = false;
      });
    }
  }
}