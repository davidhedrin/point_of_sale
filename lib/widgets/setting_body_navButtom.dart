import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/services/firebase_services.dart';

class SettingBodyMenu extends StatefulWidget {
  const SettingBodyMenu({Key? key}) : super(key: key);

  @override
  _SettingBodyMenuState createState() => _SettingBodyMenuState();
}

class _SettingBodyMenuState extends State<SettingBodyMenu> {
  final _formKey = GlobalKey<FormState>();

  bool _visible = false;
  bool _visible2 = false;
  bool isVisible = false;
  bool isVisible2 = true;
  bool _editing = true;

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _noHpController = TextEditingController();

  FirebaseServices _services = FirebaseServices();

  @override
  void initState() {
    getAdminData();
    super.initState();
  }

  Future<void> getAdminData() async {
    _services.getAdminCredentials().then((value){
      value.docs.forEach((doc) async {
        _usernameController.text = doc.get('username');
        _passwordController.text = doc.get('password');
        _noHpController.text = doc.get('no_hp');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: 270,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/bg_login.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 20.0, left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Image.asset('images/pokdakan.png', height: 80,),
                          SizedBox(width: 8.0,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget> [
                              Text(
                                'POS Pokdakan',
                                style: GoogleFonts.patuaOne(
                                  color: Colors.white,
                                  fontSize: 35,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'PT. Pokdakan Mitra Bersama',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: isVisible2,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.green,),
                              onPressed: (){
                                setState(() {
                                  isVisible = true;
                                  isVisible2 = false;
                                  _editing = false;
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: isVisible,
                            child: IconButton(
                              icon: Icon(Icons.save, color: Colors.blue,),
                              onPressed: (){
                                setState(() {
                                  isVisible = false;
                                  isVisible2 = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                height: _height * 0.70,
                width: _width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black87,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                                Text('Username Admin', style: TextStyle(fontSize: 14, color: Colors.black,),),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black87,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                              ],
                            ),

                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff8E8585),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'masukkan username';
                                }
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.black87, fontSize: 17),
                                contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                  child: Icon(Icons.account_circle_outlined, color: Colors.black, size: 40,),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),

                          SizedBox(height: 30,),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black87,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                                Text('Password Admin', style: TextStyle(fontSize: 14, color: Colors.black,),),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black87,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                              ],
                            ),

                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff8E8585),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'masukkan password';
                                }
                                /*setState(() {
                                  _phoneNumberController.text = value;
                                });*/
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
                                border: InputBorder.none,
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.black87, fontSize: 17),
                                contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                  child: Icon(Icons.password_outlined, color: Colors.black, size: 40,),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isVisible,
                            child: Column(
                              children: [
                                SizedBox(height: 15,),
                                Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff8E8585),
                                        blurRadius: 10.0,
                                        spreadRadius: 2.0,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextFormField(
                                    validator: (value){
                                      if(value!.isEmpty){
                                        return 'masukkan konfirm password';
                                      }
                                      /*setState(() {
                                  _phoneNumberController.text = value;
                                });*/
                                    },
                                    obscureText: _visible2 == false ?  true:false,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: _visible2  ? Icon(Icons.visibility, color: Colors.black,) : Icon(Icons.visibility_off, color: Colors.black.withOpacity(0.6),),
                                        onPressed: (){
                                          setState(() {
                                            _visible2 =! _visible2;
                                          });
                                        },
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Konfirm Password',
                                      hintStyle: TextStyle(color: Colors.black87, fontSize: 17),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                        child: Icon(Icons.password_outlined, color: Colors.black, size: 40,),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),

                          SizedBox(height: 30,),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black87,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                                Text('No Telepon Reset Password', style: TextStyle(fontSize: 14, color: Colors.black,),),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black87,
                                    margin: EdgeInsets.symmetric(horizontal: 12),
                                  ),
                                ),
                              ],
                            ),

                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xff8E8585),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _noHpController,
                              keyboardType: TextInputType.phone,
                              maxLength: 11,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'masukkan no handphone';
                                }
                                /*setState(() {
                                  _phoneNumberController.text = value;
                                });*/
                              },
                              decoration: InputDecoration(
                                counterText: "",
                                prefixText: '+62 ',
                                border: InputBorder.none,
                                hintText: 'No Telepon',
                                hintStyle: TextStyle(color: Colors.black87, fontSize: 20),
                                contentPadding: const EdgeInsets.symmetric(vertical: 19, horizontal: 10),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                                  child: Icon(Icons.phone_android_outlined, color: Colors.black, size: 40,),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
