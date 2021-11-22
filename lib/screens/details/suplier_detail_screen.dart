import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/suplier_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:provider/provider.dart';

class SuplierDetailScreen extends StatefulWidget {
  SuplierDetailScreen({Key? key, this.idSuplier, this.namaSuplier}) : super(key: key);
  final idSuplier, namaSuplier;

  @override
  _SuplierDetailScreenState createState() => _SuplierDetailScreenState();
}

class _SuplierDetailScreenState extends State<SuplierDetailScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  late String updateNamaSuplier;
  late String updateEmailSuplier;
  late String updateNoHpSuplier;
  late String updateAlamatSuplier;
  String? updateKetSuplier;


  bool _editing = true;
  bool isVisibleEdit = true;
  bool isVisibleSave = false;

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
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/suplierImageCard.jpg'),
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
                              child: Text(widget.namaSuplier, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
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
                                      EasyLoading.show(status: 'Updating...');
                                      if(_formKey.currentState!.validate()){
                                        EasyLoading.showSuccess('Diperbaharui');
                                        Navigator.pushReplacementNamed(context, SuplierScreen.id);
                                        _authData.updateSuplierDataToDb(
                                          suplierId: widget.idSuplier,
                                          namaSuplier: updateNamaSuplier,
                                          emailSuplier: updateEmailSuplier,
                                          noHpSuplier: updateNoHpSuplier,
                                          alamatSuplier: updateAlamatSuplier,
                                          komentar: updateKetSuplier,
                                        );
                                      }else{
                                        EasyLoading.showError('Lengkapi semua data');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Form(
                    key: _formKey,
                    child: StreamBuilder<DocumentSnapshot <Map <String, dynamic>>>(
                      stream: _services.firestore.collection('supliers').doc(widget.idSuplier).snapshots(),
                      builder: (_, snapshot){
                        if(snapshot.hasError){
                          print('Terdapat masalah');
                        }
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        var data = snapshot.data!.data();
                        var nameSuplier = data!['nama_suplier'];
                        var emailSuplier = data['email_suplier'];
                        var noHpSuplier = data['no_handpone'];
                        var alamatSuplier = data['alamat_suplier'];
                        var ketSuplier = data['komentar'];

                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                          child: AbsorbPointer(
                            absorbing: _editing,
                            child: Column(
                              children: [
                                Text(widget.idSuplier, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),),
                                Divider(color: Colors.white70,),
                                SizedBox(height: 15,),

                                TextFormField(
                                  initialValue: nameSuplier,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'masukkan nama customer';
                                    }
                                    setState(() {
                                      updateNamaSuplier = value;
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
                                    labelText: '*nama customer',
                                    prefixIcon: Icon(Icons.perm_identity, color: Colors.white,),
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                TextFormField(
                                  initialValue: emailSuplier,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'masukkan email customer';
                                    }
                                    setState(() {
                                      updateEmailSuplier = value;
                                    });
                                    final bool _isValid = EmailValidator.validate(updateEmailSuplier);
                                    if(!_isValid){
                                      return 'alamat email tidak valid';
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
                                    prefixIcon: Icon(Icons.email_rounded, color: Colors.white,),
                                    labelText: '*email customer',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                TextFormField(
                                  initialValue: noHpSuplier,
                                  autofocus: false,
                                  onChanged: (value)=>{},
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
                                      updateNoHpSuplier = value;
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
                                    prefixText: '+62 ',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    prefixIcon: Icon(Icons.phone_android, color: Colors.white,),
                                    labelText: '*no telepon',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                TextFormField(
                                  initialValue: alamatSuplier,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'masukkan alamat customer';
                                    }
                                    setState(() {
                                      updateAlamatSuplier = value;
                                    });
                                    return null;
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 8),
                                    prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white,),
                                    labelText: '*alamat customer',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                TextFormField(
                                  initialValue: ketSuplier,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  validator: (value){
                                    setState(() {
                                      updateKetSuplier = value;
                                    });
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 8),
                                    prefixIcon: Icon(Icons.comment, color: Colors.white,),
                                    labelText: 'ket customer',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                  title: Text('Hapus Customer!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  content: Text('Yakin ingin menghapus Customer', style: TextStyle(fontSize: 18,),),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Batal'),
                      onPressed: (){Navigator.of(context).pop();},
                    ),
                    CupertinoDialogAction(
                      child: Text('Iya'),
                      onPressed: (){
                        EasyLoading.showSuccess('Dihapus');
                        Navigator.pushReplacementNamed(context, SuplierScreen.id);
                        _services.suplier.doc(widget.idSuplier).delete();
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
