import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:provider/provider.dart';

//Category
class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xff363636),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pilih Category Produk', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: _services.category.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('Terjadi kesalahan');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage((document.data()! as dynamic)['imageUrl']),
                      ),
                      title: Text((document.data()! as dynamic)['category']),
                      onTap: (){
                        _provider.selectCategory((document.data()! as dynamic)['category'], (document.data()! as dynamic)['category_id']);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



//Suplier
class SuplierList extends StatefulWidget {
  const SuplierList({Key? key}) : super(key: key);

  @override
  _SuplierListState createState() => _SuplierListState();
}

class _SuplierListState extends State<SuplierList> {
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  int number = 1;

  var _ketSuplierTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  late String namaSuplier;
  late String emailSuplier;
  late String mobileSuplier;
  late String alamatSuplier;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<AuthProvider>(context);
    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color(0xff363636),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pilih Suplier', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: _services.suplier.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                return Text('Terjadi kesalahan');
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return ListTile(
                      title: Text((document.data()! as dynamic)['nama_suplier']),
                      subtitle: Text((document.data()! as dynamic)['komentar']),
                      leading: CircleAvatar(
                        child: Text('${number ++}', style: TextStyle(color: Colors.white),),
                        backgroundColor: Colors.black54,
                      ),
                      onTap: (){
                        _provider.selectSuplier((document.data()! as dynamic)['nama_suplier'], (document.data()! as dynamic)['id_suplier']);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              padding: EdgeInsets.only(right: 15.0, left: 15.0),
              color: Colors.blue,
              onPressed: (){
                openDialogTambahSuplier();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tambahkan Suplier', style: TextStyle(color: Colors.white),),
                  Icon(Icons.add, color: Colors.white,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Alertdialog tambah suplier
  openDialogTambahSuplier() {
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Tambah Suplier', style: TextStyle(fontSize: 18),),
              SizedBox(height: 5,),
              Divider(color: Colors.black45,),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'masukkan nama suplier';
                      }
                      setState(() {
                        namaSuplier = value;
                      });
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.perm_identity,),
                      labelText: '*nama suplier',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'masukkan email suplier';
                      }
                      final bool _isValid = EmailValidator.validate(_emailTextController.text);
                      if(!_isValid){
                        return 'alamat email tidak valid';
                      }
                      setState(() {
                        _emailTextController.text = value;
                      });
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.email_rounded,),
                      labelText: '*email suplier',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'masukkan nomor hp';
                      }
                      if(value.length<11){
                        return 'lengkapi nomor hp';
                      }
                      setState(() {
                        mobileSuplier = '+62' + value;
                      });
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixText: '+62 ',
                      hintStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.phone_android,),
                      labelText: '*no telepon',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (value){
                      if(value!.isEmpty){
                        return 'masukkan alamat suplier';
                      }
                      setState(() {
                        alamatSuplier = value;
                      });
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.location_on_outlined,),
                      labelText: '*alamat suplier',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _ketSuplierTextController,
                    validator: (value){
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.comment,),
                      labelText: 'komentar',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),

                  SizedBox(height: 20,),
                  FloatingActionButton(
                    onPressed: (){
                      EasyLoading.show(status: 'Menyimpan...');
                      if(_formKey.currentState!.validate()){

                        EasyLoading.showSuccess('Berhasil');
                        _formKey.currentState!.reset();
                      }
                      else{
                        EasyLoading.showInfo('Lengkapi semua data');
                      }
                    },
                    child:Icon(Icons.add, color: Colors.white,),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


