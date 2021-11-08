import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/show_password_screen.dart';

class AuthClassService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'admin';
  String? screen;
  
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context, Function setData) async {

    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBarSuccess(context, 'Verification Berhasil');
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException exception) {
      showSnackBar(context, 'Terjadi kesalahan!');
      print(exception.toString());
    };

    PhoneCodeSent codeSent = (String verificationId, [int? forceResendingtoke]){
      showSnackBarSuccess(context, 'Kode OTP berhasil terkirim');
      setData(verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (verificationId){
      print(verificationId);
    };
    try{
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
      );
    }catch(e){
      showSnackBar(context, 'Terjadi kesalahan!');
      print(e.toString());
    }
  }

  Future<void> signInWithPhoneNumber(String verificationId, String smsCode, BuildContext context,) async {
    try{
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        getUserById(user.uid).then((snapShot){
          Navigator.pushReplacementNamed(context, ShowForgotePassword.id);
          FirebaseAuth.instance.signOut();
        });
      } else {
        print('Login failed');
      }
    }catch(e){
      showSnackBar(context, e.toString());
    }
  }

  //get user data by user id
  Future<DocumentSnapshot> getUserById(String id) async {
    var result = await _firestore.collection(collection).doc(id).get();
    return result;
  }

  void showSnackBar(BuildContext context, String text){
    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.yellowAccent.withOpacity(0.5),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }  void showSnackBarSuccess(BuildContext context, String text){
    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.green.withOpacity(0.5),);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
