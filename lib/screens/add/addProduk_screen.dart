import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/produk_screen.dart';
import 'package:point_of_sale/widgets/list/suplier_category_list.dart';
import 'package:provider/provider.dart';

class AddProdukData extends StatefulWidget {
  const AddProdukData({Key? key}) : super(key: key);

  static const String id = 'addproduk-screen';

  @override
  _AddProdukDataState createState() => _AddProdukDataState();
}

class _AddProdukDataState extends State<AddProdukData> {
  final _formKey = GlobalKey<FormState>();
  File? _image;

/*  List<String> _dropdownItems = [
    'Savings',
    'Deposit',
    'Checking',
    'Brokerage'
  ];
  late String dropdownValue;*/

  var _categoryTextController = TextEditingController();
  var _ketProdukTextController = TextEditingController();
  var _suplierTextController = TextEditingController();
  late String namaProduk;
  late double hargaProduk;
  late String kodeProduk;
  late int stokProduk;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
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
    }

    return SafeArea(
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
          title: Text('Tambah Produk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
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
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xff363636),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30.0, top: 10.0),
            child: ListView(
              children: <Widget> [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Image.asset('images/produkAdd.png', height: 105,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget> [
                      //tambah gambar
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            _authData.getImage().then((image){
                              setState(() {
                                _image = image;
                              });
                            });
                          },
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child:_image == null ?  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('gambar*', style: TextStyle(fontSize: 15),),
                                  Icon(Icons.add),
                                ],
                              ) : ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.file(_image!),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //suplier
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _suplierTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'pilih suplier barang';
                                    }
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.category_outlined,),
                                    labelText: 'Suplier*',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return SuplierList();
                                  },
                                ).whenComplete((){
                                  _suplierTextController.text = _authData.selectedSuplier;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700],),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),

                      //nama ikan
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan nama ikan';
                            }
                            setState(() {
                              namaProduk = value;
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
                            prefixIcon: Icon(Icons.add_business,),
                            labelText: 'Nama produk*',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      //kode produk
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan kode produk';
                            }
                            setState(() {
                              kodeProduk = value;
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
                            prefixIcon: Icon(Icons.qr_code,),
                            labelText: 'Kode ikan*',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      //harga ikan
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan harga ikan';
                            }
                            setState(() {
                              hargaProduk = double.parse(value);
                            });
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: 'Rp. ',
                            hintStyle: TextStyle(color: Colors.white70),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.monetization_on_rounded,),
                            labelText: 'Harga ikan*',
                            suffixText: '/ kilogram',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      //stok barang
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan stok ikan';
                            }
                            setState(() {
                              stokProduk = int.parse(value);
                            });
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white70),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.add_box,),
                            labelText: 'Stok barang*',
                            suffixText: 'unit',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),

                      //pilih category
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _categoryTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'pilih kategory barang';
                                    }
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: Icon(Icons.category_outlined,),
                                    labelText: 'Category*',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return CategoryList();
                                  },
                                ).whenComplete((){
                                  _categoryTextController.text = _authData.selectedCategory;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700],),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),

                      //keterangan produk
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          controller: _ketProdukTextController,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 500,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.comment,),
                            labelText: 'keterangan',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      //tombol simpan
                      Row(
                        children: <Widget> [
                          Expanded(
                            child: FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  if(_image != null){
                                    showCupertinoDialog(
                                      context: context,
                                      builder: createDialogConfirmation,
                                    );
                                  }else{
                                    scaffomessage('Tentukan gambar produk');
                                  }
                                }else if(_formKey.currentState != null){
                                  scaffomessage('Lengkapi semua data!');
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget> [
                                  Icon(Icons.save, color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16),),
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),

                      //tanda * wajib diisi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('tanda * wajib diisi', style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),),
                        ],
                      ),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createDialogConfirmation(BuildContext context){
    final _authData = Provider.of<AuthProvider>(context);
    return CupertinoAlertDialog(
      title: Column(
        children: [
          Image.asset('images/produk.png', height: 60,),
          SizedBox(height: 10,),
          Text(
            'Tambah Produk Baru!',
            style: TextStyle(fontSize: 19),
          ),
        ],
      ),
      content: Text(
        'Apakah data Produk sudah benar?',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('batal'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text('iya'),
          onPressed: (){
            EasyLoading.show(status: 'Menyimpan...');
            _authData.uploadProdukImage(_image!.path, namaProduk).then((url){
              if(url != null){
                Navigator.pushReplacementNamed(context, ProdukScreen.id);
                EasyLoading.dismiss();
                _authData.saveProdukDataToDb(
                  context: context,
                  namaProduk: namaProduk,
                  hargaProduk: hargaProduk,
                  codeProduk: kodeProduk,
                  stokProduk: stokProduk,
                  ketProduk: _ketProdukTextController.text,
                  url: url,
                );
              }else{
                Navigator.pop(context);
                EasyLoading.showError('Gagal menyimapan');
              }
            });
          },
        ),
      ],
    );
  }
}