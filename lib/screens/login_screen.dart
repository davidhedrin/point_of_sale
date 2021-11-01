import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/register_screen.dart';
import 'package:point_of_sale/screens/reset_pw_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon? icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  late String email;
  late String password;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {

    final _authData = Provider.of<AuthProvider>(context);
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
                        controller: _emailTextController,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'masukkan alamat email';
                          }
                          final bool _isValid = EmailValidator.validate(_emailTextController.text);
                          if(!_isValid){
                            return 'format email tidak ditemukan';
                          }
                          setState(() {
                            email = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
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
                        validator: (value){
                          if(value!.isEmpty){
                            return 'masukkan password';
                          }
                          if(value.length<6){
                            return 'minimal 6 karakter';
                          }
                          setState(() {
                            password = value;
                          });
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
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child: Text(
                              'Tambahkan Admin!',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),*/
                      SizedBox(height: 10,),
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
                                ),
                              ),
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    _loading = true;
                                  });
                                  _authData.loginVendor(email, password).then((credential){
                                    if(credential != null){
                                      setState(() {
                                        _loading = false;
                                      });
                                      Navigator.pushReplacementNamed(context, HomeScreen.id);
                                    }else{
                                      setState(() {
                                        _loading = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_authData.error, textAlign: TextAlign.center,)));
                                    }
                                  });
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
                              Navigator.pushNamed(context, ResetPassword.id);
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
}
