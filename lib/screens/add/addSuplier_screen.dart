import 'package:flutter/material.dart';

class AddSuplierData extends StatefulWidget {
  const AddSuplierData({Key? key}) : super(key: key);

  static const String id = 'addsuplier-screen';

  @override
  _AddSuplierDataState createState() => _AddSuplierDataState();
}

class _AddSuplierDataState extends State<AddSuplierData> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Tambah Suplier', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {},
              color: Colors.black,
              iconSize: 28.0,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tambah Suplier screen')
            ],
          ),
        ),
      ),
    );
  }
}
