import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/screens/login2_screen.dart';
import 'package:point_of_sale/screens/login_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff363636),
      elevation: 0.0,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.power_settings_new),
          iconSize: 28.0,
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, Login2Screen.id);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
