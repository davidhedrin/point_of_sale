import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  static const String id = 'reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var _emailTextController = TextEditingController();
    late String email;
    bool _loading = false;

    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Reset Password', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/reset-pass.png', height: 170,),
                SizedBox(height: 10,),
                RichText(text: TextSpan(
                  text: '',
                  children: [
                    TextSpan(text: 'Lupa Password? \n', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30)),
                    TextSpan(text: 'Masukkan alamat email untuk menyetel ulang kata sandi anda.', style: TextStyle(color: Colors.black, fontSize: 15)),
                  ],
                ), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                TextFormField(
                  controller: _emailTextController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'masukkan alamat email';
                    }
                    final bool _isValid = EmailValidator.validate(_emailTextController.text);
                    if(!_isValid){
                      return 'format email tidak benar';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.blue,),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Expanded(
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              _loading = true;
                            });
                            _authData.resetPassword(email);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Link ubah sandi berhasil terkirim ke email Anda. Cek email Anda untuk link reset', textAlign: TextAlign.center,)));
                            Navigator.pushReplacementNamed(context, LoginScreen.id);
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        child: _loading ? LinearProgressIndicator() : Text('Reset Password', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
