import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/register_admin_screen.dart';
import 'package:point_of_sale/screens/reset_pw_admin_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';


class Login2Screen extends StatefulWidget {
  const Login2Screen({Key? key}) : super(key: key);

  static const String id = 'login2-screen';

  @override
  _Login2ScreenState createState() => _Login2ScreenState();
}

class _Login2ScreenState extends State<Login2Screen> {
  final _formKey = GlobalKey<FormState>();
  bool _visible = false;
  bool _loading = false;
  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  late String username, password;

  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 3,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500)
    );


    Future<void> _login() async {
      progressDialog.show();
      _services.getAdminCredentials().then((value){
        value.docs.forEach((doc) async {
          if(doc.get('username') == username){
            if(doc.get('password') == password){
              UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
              progressDialog.dismiss();
              if(userCredential.user!.uid != null){
                Navigator.pushReplacementNamed(context, HomeScreen.id);
                return;
              }else{
                _showMyDialog(
                  tittle: 'Login!',
                  message: 'Gagal menghubungkan, Login kembali!',
                );
              }
            }else{
              progressDialog.dismiss();
              _showMyDialog(
                tittle: 'Password Salah',
                message: 'Masukkan PASSWORD yang benar!',
              );
            }
          }else{
            progressDialog.dismiss();
            _showMyDialog(
              tittle: 'Username Salah',
              message: 'Masukkan USERNAME yang benar!',
            );
          }
        });
      });
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg_login.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Login', style: TextStyle(color: Colors.blue, fontFamily: 'Anton', fontSize: 35),),
                          SizedBox(width: 7,),
                          Image.asset('images/pokdakan.png', height: 55,),
                        ],
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _usernameTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'masukkan username';
                          }
                          setState(() {
                            username = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Username',
                          fillColor: Colors.white.withOpacity(0.5),
                          filled: true,
                          prefixIcon: Icon(Icons.email, color: Colors.black,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: _passwordTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'masukkan password';
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        obscureText: _visible == false ?  true:false,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible ? Icon(Icons.visibility, color: Colors.black,) : Icon(Icons.visibility_off, color: Colors.black.withOpacity(0.6),),
                            onPressed: (){
                              setState(() {
                                _visible =! _visible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          fillColor: Colors.white.withOpacity(0.5),
                          filled: true,
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.black,),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),

                      //tambahkan admin
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ingin menambahan admin? ', style: TextStyle(color: Colors.grey),),
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, RegisterAdminScreen.id);
                            },
                            child: Text(
                              'Tambahkan Admin!',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),*/

                      Row(
                        children: [
                          Expanded(
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              color: Theme.of(context).primaryColor,
                              child: _loading ? LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                backgroundColor: Colors.transparent,
                              ) : Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                    fontSize: 17
                                ),
                              ),
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  _login();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 7,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, ResetPasswordAdmin.id);
                            },
                            child: Text(
                              'lupa password?',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog({tittle, message,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tittle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                Text('Coba lagi'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok', style: TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
