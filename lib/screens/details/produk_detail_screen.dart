import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/produk_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:point_of_sale/widgets/list/suplier_category_list.dart';
import 'package:provider/provider.dart';

class ProdukDetailScreen extends StatefulWidget {
  ProdukDetailScreen({Key? key, this.idProduk, this.namaProduk,}) : super(key: key);
  final idProduk, namaProduk;

  @override
  _ProdukDetailScreenState createState() => _ProdukDetailScreenState();
}

class _ProdukDetailScreenState extends State<ProdukDetailScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  var _namaProdukController = TextEditingController();
  var _suplierTextController = TextEditingController();
  var _idsuplierTextController = TextEditingController();
  var _kodeProdukTextController = TextEditingController();
  var _hargaProdukTextController = TextEditingController();
  var _stokProdukTextController = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _idcategoryTextController = TextEditingController();
  var _ketProdukTextController = TextEditingController();
  var _imgProdukTextController = TextEditingController();
  File? _image;

  bool _editing = true;
  bool isVisibleEdit = true;
  bool isVisibleSave = false;

  @override
  void initState() {
    getProdukDetailData();
    super.initState();
  }

  Future<void> getProdukDetailData() async {
    _services.produk.doc(widget.idProduk).get().then((DocumentSnapshot document){
      if(document.exists){
        setState(() {
          _namaProdukController.text = (document.data()! as dynamic)['nama_produk'];
          _suplierTextController.text = (document.data()! as dynamic)['suplier_produk']['nama_suplier'];
          _idsuplierTextController.text = (document.data()! as dynamic)['suplier_produk']['id_suplier'];
          _kodeProdukTextController.text = (document.data()! as dynamic)['kode_produk'];
          _hargaProdukTextController.text = (document.data()! as dynamic)['harga_produk'].toStringAsFixed(0);
          _stokProdukTextController.text = (document.data()! as dynamic)['stok_produk'].toString();
          _categoryTextController.text = (document.data()! as dynamic)['category_produk']['nama_category'];
          _idcategoryTextController.text = (document.data()! as dynamic)['category_produk']['id_category'];
          _ketProdukTextController.text = (document.data()! as dynamic)['ket_produk'];
          _imgProdukTextController.text = (document.data()! as dynamic)['imageUrl'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff363636),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: FutureBuilder<DocumentSnapshot <Map <String, dynamic>>>(
                      future: _services.firestore.collection('produks').doc(widget.idProduk).get(),
                      builder: (_, snapshot){
                        if(snapshot.hasError){
                          print('Terdapat masalah');
                        }
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('${_imgProdukTextController.text}'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Column(
                                    children: [
                                      Text(widget.namaProduk, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
                                      Text('- '+_kodeProdukTextController.text+' -', style: TextStyle(color: Colors.white, fontSize: 18),),
                                      SizedBox(height: 15,),
                                      AbsorbPointer(
                                        absorbing: _editing,
                                        child: InkWell(
                                          onTap: (){
                                            _authData.getImage().then((image){
                                              setState(() {
                                                _image = image;
                                              });
                                            });
                                          },
                                          child:_image == null ? ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            child: Image.network('${_imgProdukTextController.text}', width: 80,),
                                          ) : ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(100)),
                                            child: Image.file(_image!, width: 80,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: isVisibleEdit,
                                      child: IconButton(
                                          icon: Icon(Icons.edit, color: Colors.green, size: 30,),
                                          onPressed: (){
                                            setState(() {
                                              _editing = false;
                                              isVisibleEdit = false;
                                              isVisibleSave = true;
                                            });
                                          }
                                      ),
                                    ),
                                    Visibility(
                                      visible: isVisibleSave,
                                      child: IconButton(
                                        icon: Icon(Icons.save, color: Colors.blue, size: 30,),
                                        onPressed: (){
                                          if(_formKey.currentState!.validate()){
                                            EasyLoading.show(status: 'Updating...');
                                            if(_image != null){
                                              _authData.uploadProdukImage(_image!.path, _namaProdukController.text).then((url){
                                                if(url != null){
                                                  EasyLoading.showSuccess('Diperbaharui');
                                                  Navigator.of(context).pop();
                                                  _authData.updateProdukDataToDb(
                                                    context: context,
                                                    idProduk: widget.idProduk,
                                                    namaProduk: _namaProdukController.text,
                                                    hargaProduk: double.parse(_hargaProdukTextController.text),
                                                    stokProduk: int.parse(_stokProdukTextController.text),
                                                    ketProduk: _ketProdukTextController.text,
                                                    image: url,
                                                    namaSupProduk: _suplierTextController.text,
                                                    idSup: _idsuplierTextController.text,
                                                    namaCatProduk: _categoryTextController.text,
                                                    idCat: _idcategoryTextController.text,
                                                  );
                                                }
                                              });
                                            }else{
                                              EasyLoading.showSuccess('Diperbaharui');
                                              Navigator.of(context).pop();
                                              _authData.updateProdukDataToDb(
                                                context: context,
                                                idProduk: widget.idProduk,
                                                namaProduk: _namaProdukController.text,
                                                hargaProduk: double.parse(_hargaProdukTextController.text),
                                                stokProduk: int.parse(_stokProdukTextController.text),
                                                ketProduk: _ketProdukTextController.text,
                                                image: _imgProdukTextController.text,
                                                namaSupProduk: _suplierTextController.text,
                                                idSup: _idsuplierTextController.text,
                                                namaCatProduk: _categoryTextController.text,
                                                idCat: _idcategoryTextController.text,
                                              );
                                            }
                                          }else{
                                            EasyLoading.showInfo('Lengkapi Data!');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                    child: Form(
                      key: _formKey,
                      child: AbsorbPointer(
                        absorbing: _editing,
                        child: Column(
                          children: [
                            Text(widget.idProduk, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),),
                            Divider(color: Colors.white70,),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      controller: _suplierTextController,
                                      autofocus: false,
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
                                        prefixIcon: Icon(Icons.category_outlined, color: Colors.white,),
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
                                      setState(() {
                                        _suplierTextController.text = _authData.selectedSuplier!;
                                        _idsuplierTextController.text = _authData.id_Suplier!;
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700],),
                                ),
                              ],
                            ),

                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _namaProdukController,
                              autofocus: false,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'masukkan nama Produk';
                                }
                                /*setState(() {
                                  updateNamaCusotmer = value;
                                });*/
                                return null;
                              },
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                labelText: 'Nama produk*',
                                prefixIcon: Icon(Icons.perm_identity, color: Colors.white,),
                                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                            ),

                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _hargaProdukTextController,
                              autofocus: false,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'masukkan harga ikan';
                                }
                                /*setState(() {
                                  hargaProduk = double.parse(value);
                                });*/
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
                                prefixIcon: Icon(Icons.monetization_on_rounded, color: Colors.white,),
                                labelText: 'Harga ikan*',
                                suffixText: '/ kilogram',
                                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                            ),

                            SizedBox(height: 15,),
                            TextFormField(
                              controller: _stokProdukTextController,
                              autofocus: false,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'masukkan stok ikan';
                                }
                                /*setState(() {
                                  stokProduk = int.parse(value);
                                });*/
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
                                prefixIcon: Icon(Icons.add_box, color: Colors.white,),
                                labelText: 'Stok barang*',
                                suffixText: 'unit',
                                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                            ),

                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      autofocus: false,
                                      controller: _categoryTextController,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        prefixIcon: Icon(Icons.category_outlined, color: Colors.white,),
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
                                      _categoryTextController.text = _authData.selectedCategory!;
                                      _idcategoryTextController.text = _authData.id_Category!;
                                    });
                                  },
                                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[700],),
                                ),
                              ],
                            ),

                            SizedBox(height: 15,),
                            TextFormField(
                              autofocus: false,
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
                                prefixIcon: Icon(Icons.comment, color:Colors.white,),
                                labelText: 'keterangan',
                                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return CupertinoAlertDialog(
                  title: Text('Hapus Produk!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  content: Text('Yakin ingin menghapus Produk', style: TextStyle(fontSize: 18,),),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Batal'),
                      onPressed: (){Navigator.of(context).pop();},
                    ),
                    CupertinoDialogAction(
                      child: Text('Iya'),
                      onPressed: (){
                        EasyLoading.showSuccess('Dihapus');
                        Navigator.pushReplacementNamed(context, ProdukScreen.id);
                        _services.customer.doc(widget.idProduk).delete();
                      },
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.delete_forever, color: Colors.white, size: 30,),
        ),
      ),
    );
  }
}