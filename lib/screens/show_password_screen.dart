import 'package:flutter/material.dart';

class ShowForgotePassword extends StatefulWidget {
  const ShowForgotePassword({Key? key}) : super(key: key);

  static const String id = 'show-forgote-password-screen';

  @override
  _ShowForgotePasswordState createState() => _ShowForgotePasswordState();
}

class _ShowForgotePasswordState extends State<ShowForgotePassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff363636),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white70,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Password',
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('Ini show Password Lupa')),
          ],
        ),
      ),
    );
  }
}
