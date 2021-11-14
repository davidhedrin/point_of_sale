import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/category_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatefulWidget {
  CategoryDetailScreen({Key? key, this.idCategory}) : super(key: key);
  final idCategory;

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  bool _editing = true;
  bool isVisibleEdit = true;
  bool isVisibleSave = false;

  final _formKey = GlobalKey<FormState>();
  final FirebaseServices _services = FirebaseServices();

  var _namaCategoryController = TextEditingController();
  var _imgCategoryTextController = TextEditingController();
  File? _image;

  @override
  void initState() {
    getCategoryDetailData();
    super.initState();
  }

  Future<void> getCategoryDetailData() async {
    _services.category.doc(widget.idCategory).get().then((DocumentSnapshot document){
      if(document.exists){
        setState(() {
          _namaCategoryController.text = (document.data()! as dynamic)['category'];
          _imgCategoryTextController.text = (document.data()! as dynamic)['imageUrl'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff363636),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: FutureBuilder<DocumentSnapshot <Map <String, dynamic>>>(
                  future: _services.firestore.collection('categorys').doc(widget.idCategory).get(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      print('Terdapat masalah');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('${_imgCategoryTextController.text}'),
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
                                  Text(_namaCategoryController.text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
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
                                        child: Image.network('${_imgCategoryTextController.text}', width: 80,),
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

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
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
                        Text(widget.idCategory, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 20,),),
                        Divider(color: Colors.white70,),
                        SizedBox(height: 15,),


                        TextFormField(
                          controller: _namaCategoryController,
                          autofocus: false,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan category Produk';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: 'Category*',
                            prefixIcon: Icon(Icons.category_outlined, color: Colors.white,),
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return CupertinoAlertDialog(
                  title: Text('Hapus Category!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  content: Text('Yakin ingin menghapus Category', style: TextStyle(fontSize: 18,),),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Batal'),
                      onPressed: (){Navigator.of(context).pop();},
                    ),
                    CupertinoDialogAction(
                      child: Text('Iya'),
                      onPressed: (){
                        EasyLoading.showSuccess('Dihapus');
                        Navigator.pushReplacementNamed(context, CategoryScreen.id);
                        _services.customer.doc(widget.idCategory).delete();
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
