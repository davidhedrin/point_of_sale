import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/services/phone_auth_service.dart';

class ResetPasswordAdmin extends StatefulWidget {
  const ResetPasswordAdmin({Key? key}) : super(key: key);

  static const String id = 'reset-admin-screen';

  @override
  _ResetPasswordAdminState createState() => _ResetPasswordAdminState();
}

class _ResetPasswordAdminState extends State<ResetPasswordAdmin> {

  final _formKey = GlobalKey<FormState>();
  int start = 30;
  bool wait = false;
  String bottomName = 'Kirim';

  TextEditingController _phoneNumberController = TextEditingController();
  AuthClassService authClass = AuthClassService();
  String verificationId_Final = '';
  String kodeOtp = '';

  bool isVisible = false;

  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        title: Text('Reset Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 90,),
              Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: Image.asset('images/reset_password_sms_otp.png',),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: Text(
                  'Kode OTP reset password akan dikirim melalui SMS pada nomor telepon yang terdaftar!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'masukkan nomor';
                      }
                      setState(() {
                        _phoneNumberController.text = value;
                      });
                    },
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: 'Masukkan nomor',
                      hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
                      contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                        child: Text("(+62)", style: TextStyle(color: Colors.white, fontSize: 17),),
                      ),
                      suffixIcon: InkWell(
                        onTap: wait ? null : () async {
                          String phoneNumber = '+62${_phoneNumberController.text}';
                          if(_formKey.currentState!.validate()){
                            EasyLoading.show(status: 'Meminta...');
                            _services.getAdminCredentials().then((value){
                              value.docs.forEach((doc) async {
                                if(doc.get('no_hp') == phoneNumber){
                                  isVisible = true;
                                  EasyLoading.dismiss();
                                  await authClass.verifyPhoneNumber(phoneNumber = phoneNumber, context, setData);
                                  startTimer();
                                  setState(() {
                                    start = 30;
                                    wait = true;
                                    bottomName = 'Ulang';
                                  });
                                }else{
                                  EasyLoading.dismiss();
                                  authClass.showSnackBar(context, 'Nomor salah');
                                }
                              });
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          child: Text(
                            bottomName,
                            style: TextStyle(
                              color: wait ? Colors.grey : Colors.white,
                              fontSize: 17, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    Text('Masukkan 6 Digit OTP', style: TextStyle(fontSize: 14, color: Colors.white,),),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ],
                ),

              ),

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width - 30,
                  fieldWidth: 50,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.black12,
                    borderColor: Colors.white,
                  ),
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onChanged: (pin){
                    kodeOtp = pin;
                  },
                  onCompleted: (pin) {
                    setState(() {
                      kodeOtp = pin;
                    });
                  },
                ),
              ),

              SizedBox(height: 15,),
              wait ? Visibility(
                visible: isVisible,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Kirim ulang OTP dalam ',
                        style: TextStyle(fontSize: 16, color: Colors.yellowAccent,),
                      ),
                      TextSpan(
                        text: '00:${start}',
                        style: TextStyle(fontSize: 16, color: Colors.red,),
                      ),
                      TextSpan(
                        text: ' detik',
                        style: TextStyle(fontSize: 16, color: Colors.yellowAccent,),
                      ),
                    ]
                  ),
                ),
              ) : Visibility(
                visible: false,
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(text: '',),
                      ]
                  ),
                ),
              ),

              SizedBox(height: 15,),
              Visibility(
                visible: isVisible,
                child: FlatButton(
                  // ignore: deprecated_member_use
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 18.0),
                  onPressed: (){
                    String phoneNumber2 = '+62${_phoneNumberController.text}';
                    if(kodeOtp.length == 6){
                      authClass.signInWithPhoneNumber(
                        verificationId_Final,
                        kodeOtp,
                        context,
                      );
                      authClass.getKonfirmNoHp(phoneNumber2);
                    }else{
                      authClass.showSnackBar(
                        context,
                        'Masukkan 6 digit OTP',
                      );
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  child:Text('Verifikasi', style: TextStyle(color: Colors.white, fontSize: 17),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer(){
    const onSec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onSec, (timer) {
      if(start == 0){
        setState(() {
          timer.cancel();
          wait = false;
          bottomName = 'Kirim';
        });
      }else{
        setState(() {
          start --;
        });
      }
    });
  }

  void setData(String verificationId){
    setState(() {
      verificationId_Final = verificationId;
    });
    startTimer();
  }
}
