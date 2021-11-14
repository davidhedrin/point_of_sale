import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/services/phone_auth_service.dart';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({Key? key}) : super(key: key);

  static const String id = 'register-admin-screen';

  @override
  _RegisterAdminScreenState createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  var _phoneNumberController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cpasswordTextController = TextEditingController();

  AuthClassService authClass = AuthClassService();

  bool _visible1 = false;
  bool _visible2 = false;

  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    scaffomessage(message){
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.yellowAccent.withOpacity(0.5),
        ),
      );
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Color(0xff363636),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Tambah Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _formKey.currentState!.reset();
              },
              color: Colors.white70,
              iconSize: 28.0,
            ),
          ],
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'masukkan nomor hp';
                              }
                              if(value.length<11){
                                return 'lengkapi nomor hp';
                              }
                              return null;
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              prefixText: '+62 ',
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(Icons.phone_android,),
                              labelText: '*no telepon',
                              labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty){
                                return 'masukkan username';
                              }
                              setState(() {
                                username = value;
                              });
                              return null;
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(Icons.account_circle_outlined),
                              labelText: 'Username',
                              labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            controller: _passwordTextController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'masukkan password';
                              }
                              if(value.length<6){
                                return 'minimal 6 karakter';
                              }
                              if(_passwordTextController.text != _cpasswordTextController.text){
                                return 'passwod tidak sama';
                              }
                              setState(() {
                                _passwordTextController.text = value;
                              });
                              return null;
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            obscureText: _visible1 == false ?  true:false,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _visible1 ? Icon(Icons.visibility, color: Colors.black,) : Icon(Icons.visibility_off, color: Colors.black.withOpacity(0.6),),
                                onPressed: (){
                                  setState(() {
                                    _visible1 =! _visible1;
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(Icons.vpn_key),
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            controller: _cpasswordTextController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'konfirmasi password';
                              }
                              if(_passwordTextController.text != _cpasswordTextController.text){
                                return 'passwod tidak sama';
                              }
                              if(value.length<6){
                                return 'minimal 6 karakter';
                              }
                              return null;
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            obscureText: _visible2 == false ?  true:false,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _visible2 ? Icon(Icons.visibility, color: Colors.black,) : Icon(Icons.visibility_off, color: Colors.black.withOpacity(0.6),),
                                onPressed: (){
                                  setState(() {
                                    _visible2 =! _visible2;
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(Icons.vpn_key),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                color: Colors.blue,
                                onPressed: (){
                                  if(_formKey.currentState!.validate()){
                                    EasyLoading.show(status: 'Tunggu...');
                                    String number = '+62${_phoneNumberController.text}';
                                    _services.getAdminCredentials().then((value){
                                      value.docs.forEach((doc) {
                                        if(doc.get('id_admin') != number){
                                          EasyLoading.showSuccess('Terdaftar!');
                                          authClass.verifyPhone(
                                            context : context,
                                            number : number,
                                          ).then((value){
                                            _formKey.currentState!.reset();
                                            setState(() {
                                              authClass.loading = false;
                                            });
                                          });
                                          authClass.getUsername(username);
                                          authClass.getPassword(_passwordTextController.text);
                                          authClass.getNoHp(number);
                                        }else{
                                          EasyLoading.showError('Nomor sudah terdaftar');
                                        }
                                      });
                                    });
                                  }else if(_formKey.currentState != null){
                                    scaffomessage('Lengkapi semua data!');
                                  }
                                },
                                child: Text('Tambahkan', style: TextStyle(color: Colors.white, fontSize: 15),),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
