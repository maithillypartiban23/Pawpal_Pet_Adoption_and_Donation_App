import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpal_pet_adoption/myconfig.dart';
import 'package:pawpal_pet_adoption/models/user.dart';
import 'package:pawpal_pet_adoption/views/mainpage.dart';
import 'package:pawpal_pet_adoption/views/registerpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  bool visible = true;
  bool isChecked = false;
  late double height, width;
  late User user;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

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
    title: const Text('Login Page'),
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
                // LOGO
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/pawpal.png',
                    scale: 1.5,
                  ),
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
                      border: OutlineInputBorder(),
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
                          setState(() {
                            visible = !visible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Remember Me
                  Row(
                    children: [
                      const Text(
                        'Remember Me',
                         style: TextStyle(color: Color(0xFF8B5E3C)),
                        ),
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() => isChecked = value!);

                          if (isChecked) {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              prefUpdate(true);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Preferences Stored"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              isChecked = false;
                              setState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Please fill your email and password"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            prefUpdate(false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Preferences Removed"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            emailController.clear();
                            passwordController.clear();
                          }
                        },
                      ),
                    ],
                  ),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC97C5D),
                    foregroundColor: Colors.white,
                     ),
                      onPressed: loginUser,
                      child: const Text('Login'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      );
                    },
                     child: const Text(
                    "Don't have an account? Register here.",
                     style: TextStyle(
                     color: Color(0xFF8B5E3C), 
                     fontWeight: FontWeight.w500,
                    ),
                   ),
                  ),

                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all the fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords must be more than or equal to 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await http.post(
      Uri.parse("${MyConfig.baseUrl}/pawpal_pet_adoption/api/login_user.php"),
       body: {
        'email': email,
        'password': password,
        },
      )
        .then((response) {
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(resarray.toString());

              if (resarray['status'] == 'success') {
              user = User.fromJson(resarray['data'][0]);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );            
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(user: user),
                ),
              );
            } else {
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
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
    
  }
}