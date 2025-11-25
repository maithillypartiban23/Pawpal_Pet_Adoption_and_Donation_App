import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpal_pet_adoption/myconfig.dart';
import 'package:pawpal_pet_adoption/views/mainpage.dart';
import 'package:pawpal_pet_adoption/views/loginpage.dart';
import 'package:pawpal_pet_adoption/models/user.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    autologin();
  }

  void autologin() {
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberme = prefs.getBool("rememberMe");
      if (rememberme != null && rememberme) {
        email = prefs.getString("email") ?? "";
        password = prefs.getString("password") ?? "";

        http
            .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal_pet_adoption/api/login_user.php'),
          body: {"email": email, "password": password},
        )
            .then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);

            if (jsondata['status'] == 'success') {
              if (!mounted) return;

              Future.delayed(const Duration(seconds: 3), () {
                User user = User.fromJson(jsondata['data'][0]);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage(user: user)),
                );
              });
            } else {
              if (!mounted) return;

              Future.delayed(const Duration(seconds: 3), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              });
            }
          } else {
            if (!mounted) return;

            Future.delayed(const Duration(seconds: 3), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            });
          }
        });
      } else {
        if (!mounted) return;
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/pawpal.png', scale: 3),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Color(0xFFA66A46)),
              const SizedBox(height: 20),
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFA66A46),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
