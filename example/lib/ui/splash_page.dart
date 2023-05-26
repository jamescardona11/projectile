import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:example/ui/home_page.dart';
import 'package:example/ui/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage();

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _simulateSplashTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Image.asset(
                'assets/splash_image.png',
                width: 100,
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _simulateSplashTime() {
    Future.delayed(const Duration(milliseconds: 1500), _isLogin);
  }

  // random function
  // possible improve: add sharedPreferences to save the login
  void _isLogin() {
    final isLogin = Random(DateTime.now().millisecondsSinceEpoch).nextBool();
    late MaterialPageRoute materialRoute;

    if (isLogin) {
      materialRoute = MaterialPageRoute(
        builder: (context) => HomePage(),
      );
    } else {
      materialRoute = MaterialPageRoute(
        builder: (context) => LoginPage(),
      );
    }

    Navigator.pushReplacement(context, materialRoute);
  }
}
