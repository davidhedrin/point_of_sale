import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _cpasswordTextController = TextEditingController();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffomessage(message){
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message, textAlign: TextAlign.center,)));
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return 'masukkan email';
                }
                final bool _isValid = EmailValidator.validate(_emailTextController.text);
                if(!_isValid){
                  return 'format email tidak didukung';
                }
                setState(() {
                  email = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                labelText: 'Alamat Email',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, color: Colors.blue
                  ),
                ),
                focusColor: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              validator: (value){
                if(value!.isEmpty){
                  return 'masukkan password';
                }
                if(_passwordTextController.text != _cpasswordTextController.text){
                  return 'passwod tidak sama';
                }
                if(value.length<6){
                  return 'minimal 6 karakter';
                }
                setState(() {
                  password = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                labelText: 'Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Colors.blue
                  ),
                ),
                focusColor: Colors.blue,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _cpasswordTextController,
              obscureText: true,
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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                labelText: 'Konfirmasi Password',
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Colors.blue
                  ),
                ),
                focusColor: Colors.blue,
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
                      _authData.registerAdmin(email, password).then((credential){
                        if(credential.user!.uid!=null){
                          Navigator.pushReplacementNamed(context, HomeScreen.id);
                        }
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
    );
  }
}
