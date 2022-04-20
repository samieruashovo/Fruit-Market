import 'dart:async';

import 'package:e_commerce_app/ui/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    Timer(
        const Duration(seconds: 0),
        () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const LoginScreen())));
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
