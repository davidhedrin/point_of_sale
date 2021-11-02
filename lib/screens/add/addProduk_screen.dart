import 'package:flutter/material.dart';

class AddProdukData extends StatefulWidget {
  const AddProdukData({Key? key}) : super(key: key);

  static const String id = 'addproduk-screen';

  @override
  _AddProdukDataState createState() => _AddProdukDataState();
}

class _AddProdukDataState extends State<AddProdukData> {
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
          title: Text('Tambah Produk', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),),
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
              Text('Tambah Produk screen')
            ],
          ),
        ),
      ),
    );
  }
}
