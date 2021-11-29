import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/screens/login2_screen.dart';
import 'package:point_of_sale/services/phone_auth_service.dart';

class ShowForgotePassword extends StatefulWidget {
  ShowForgotePassword({Key? key, this.konfirmNoHp}) : super(key: key);
  final konfirmNoHp;

  static const String id = 'show-forgote-password-screen';

  @override
  _ShowForgotePasswordState createState() => _ShowForgotePasswordState();
}

class _ShowForgotePasswordState extends State<ShowForgotePassword> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;


  var _passwordTextController = TextEditingController();
  var _cpasswordTextController = TextEditingController();


  AuthClassService authClass = AuthClassService();

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Color(0xff363636),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white70,
            onPressed: () => Navigator.pushReplacementNamed(context, Login2Screen.id),
          ),
          title: Text(
            'New Password',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
          /*actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
              color: Colors.white70,
              iconSize: 28.0,
            ),
          ],*/
        ),
        body: ListView(
          children: [
            SizedBox(height: 30,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Image.asset('images/resetNewPassword.png'),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: TextFormField(
                      controller: _passwordTextController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'masukkan password';
                        }
                        if(_passwordTextController.text != _cpasswordTextController.text){
                          return 'passwod tidak sama';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'New Password',
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
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: TextFormField(
                      controller: _cpasswordTextController,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'masukkan konfirmasi password';
                        }
                        if(_passwordTextController.text != _cpasswordTextController.text){
                          return 'passwod tidak sama';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Konfirmasi new Password',
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
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13.0),
                            color: Theme.of(context).primaryColor,
                            child: _loading ? LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.transparent,
                            ) : Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17
                              ),
                            ),
                            onPressed: (){
                              EasyLoading.show(status: 'Mengubah...');
                              if(_formKey.currentState!.validate()){
                                EasyLoading.showSuccess('Success');
                                Navigator.pushReplacementNamed(context, Login2Screen.id);
                                authClass.updatePasswordAdminToDb(
                                  idNoHpAdmin: widget.konfirmNoHp,
                                  password: _passwordTextController.text,
                                );
                              }else{
                                EasyLoading.showInfo(_passwordTextController.text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
