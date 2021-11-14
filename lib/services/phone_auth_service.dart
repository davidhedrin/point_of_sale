import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/login2_screen.dart';
import 'package:point_of_sale/screens/show_password_screen.dart';

class AuthClassService with ChangeNotifier{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = 'admin';
  String? screen;

  bool loading = false;
  String error = '';
  late String smsOtp;
  late String verificationId;
  
  FirebaseAuth _auth = FirebaseAuth.instance;


  late String getusername;
  getUsername(username){
    this.getusername = username;
  }
  late String getpasswrod;
  getPassword(password){
    this.getpasswrod = password;
  }
  late String getnohp;
  getNoHp(noHandphone){
    this.getnohp = noHandphone;
  }


  late String getkonfirmNoHp;
  getKonfirmNoHp(noKonfHandphone){
    this.getkonfirmNoHp = noKonfHandphone;
  }

  //LoginAdmin
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
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context){
                return ShowForgotePassword(
                  konfirmNoHp: this.getkonfirmNoHp,
                );
              },
            ),
          );
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


  //REGISTER NEW ADMIN
  Future<void> verifyPhone({required BuildContext context, required String number}) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
      this.verificationId = verId;
      //open dialog to enter OTP
      smsOtpDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();
      print(e);
    }
  }
  Future<void> smsOtpDialog(BuildContext context, String number) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(height: 5,),
                Text(
                  'Enter 6 digit OTP code',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                    PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsOtp,);


                    final User? user = (await _auth.signInWithCredential(credential)).user;
                    if (user != null) {
                      getUserById(user.uid).then((snapShot){
                        Navigator.pushReplacementNamed(context, Login2Screen.id);
                        FirebaseAuth.instance.signOut();
                        addNewAdminToDb(
                          username: this.getusername,
                          password: this.getpasswrod,
                          noHandphone: this.getnohp,
                        );
                      });
                    } else {
                      print('Login failed');
                    }

                  } catch (e) {
                    this.error = 'Invalid OTP';
                    notifyListeners();
                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        }).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }


  Future<void>? addNewAdminToDb({username, noHandphone, password}) {
    CollectionReference _password = FirebaseFirestore.instance.collection('admin');
    try{
      _password.doc(noHandphone).set({
        'id_admin' : noHandphone,
        'no_hp' : noHandphone,
        'username' : username,
        'password': password,
      });
    }catch(e){
      this.alertDialog(
        title: 'Simpan Produk',
        content: '${e.toString()}',
      );
    }
  }
  Future<void>? updatePasswordAdminToDb({idNoHpAdmin, password}) {
    CollectionReference _password = FirebaseFirestore.instance.collection('admin');
    try{
      _password.doc(idNoHpAdmin).update({'password': password});
    }catch(e){
      this.alertDialog(
        title: 'Simpan Produk',
        content: '${e.toString()}',
      );
    }
  }

  alertDialog({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        actions: [
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }
}
