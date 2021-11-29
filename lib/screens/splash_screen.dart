import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/login2_screen.dart';
import 'package:point_of_sale/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() async {
    if(await checkInternet()){
      Timer(
          Duration(
            seconds: 3,
          ), () {

        //admin auth
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if(user == null){
              Navigator.pushReplacementNamed(context, Login2Screen.id);
            }else{
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            }
          });

          //email login
          /*FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if(user == null){
            }else{
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            }
          });*/
        }
      );
    }else{

    }
  }

  Future<bool> checkInternet() async {
    var conResault = await (Connectivity().checkConnectivity());
    if (conResault == ConnectivityResult.mobile || conResault == ConnectivityResult.wifi){
      return true;
    }else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: checkInternet(),
          builder: (BuildContext context, snapshot){
            if(snapshot.data == null){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/pokdakan.png'),
                  Text('Podokma Mitra Bersama',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                ],
              );
            }else if(snapshot.data == true){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/pokdakan.png'),
                  Text('Podokma Mitra Bersama',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                ],
              );
            }else{
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/noInternet.png', width: 100,),
                  Text('Tidak ada koneksi!',  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Muat Ulang',  style: TextStyle(color: Colors.blue, fontSize: 16),),
                        Icon(Icons.refresh, size: 17, color: Colors.blue,),
                      ],
                    ),
                    onPressed: (){
                      setState(() {
                        initTimer();
                      });
                    },
                  ),
                ],
              );
            }
          },
        ),

        /*Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/pokdakan.png'),
            Text('Podokma Mitra Bersama',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ],
        ),*/
      ),
    );
  }


}
