import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/category_screen.dart';
import 'package:point_of_sale/widgets/image_picker_category.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  static const String id = 'addcategory-screen';

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  var _categoryTextController = TextEditingController();
  late String categoryName;

  //kalau punya image
  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('uploads/categoryPicture/${_categoryTextController.text}').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    //upload url link to database
    String downloadURL = await _storage.ref('uploads/categoryPicture/${_categoryTextController.text}').getDownloadURL();

    return downloadURL;
  }

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
    };

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
          title: Text(
            'Tambah Category',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
          ),
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
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset('images/categoryAdd.png', height: 110,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              CategoryPicCard(),
                              SizedBox(height: 8,),
                              Text('Gambar category', style: TextStyle(color: Colors.grey[600]),),
                            ],
                          ),
                        ),
                        SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: TextFormField(
                            controller: _categoryTextController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'masukkan category';
                              }
                              setState(() {
                                _categoryTextController.text = value;
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
                              prefixIcon: Icon(Icons.category_outlined,),
                              labelText: 'Category',
                              labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                color: Colors.blue,
                                onPressed: () {
                                  if(_authData.isPickAvail == true){
                                    if(_formKey.currentState!.validate()){
                                      showCupertinoDialog(
                                        context: context,
                                        builder: createDialogConfirmation,
                                      );
                                    }else if(_formKey.currentState != null){
                                      scaffomessage('Lengkapi semua data!');
                                    }
                                  }else{
                                    scaffomessage('Tentukan gambar category!');
                                  }
                                },

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget> [
                                    Icon(Icons.add_circle, color: Colors.white,),
                                    SizedBox(width: 5,),
                                    Text('Tambah', style: TextStyle(color: Colors.white, fontSize: 16),),
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
                      ],
                    ),
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
          Image.asset('images/category.png', height: 60,),
          SizedBox(height: 10,),
          Text(
            'Tambah Category Baru!',
            style: TextStyle(fontSize: 19),
          ),
        ],
      ),
      content: Text(
        'Apakah data category sudah benar?',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('batal'),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text('iya'),
          onPressed: (){
            EasyLoading.show(status: 'Menyimpan...');
            uploadFile(_authData.image.path).then((url){
              if(url!=null){
                Navigator.pushReplacementNamed(context, CategoryScreen.id);
                EasyLoading.showSuccess('Category tersimpan');
                _authData.saveCategoryDataToDb(
                  url: url,
                  category: _categoryTextController.text,
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
