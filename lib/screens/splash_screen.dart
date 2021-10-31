import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if(user == null){
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/pokdakan.png'),
            Text('Podokma Mitra Bersama',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
