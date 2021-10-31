import 'package:flutter/material.dart';

class SettingBodyMenu extends StatefulWidget {
  const SettingBodyMenu({Key? key}) : super(key: key);

  @override
  _SettingBodyMenuState createState() => _SettingBodyMenuState();
}

class _SettingBodyMenuState extends State<SettingBodyMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Setting'),
          ],
        ),
      ),
    );
  }
}
