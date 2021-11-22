import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/customer_screen.dart';
import 'package:point_of_sale/services/firebase_services.dart';
import 'package:provider/provider.dart';

class CustomerDetailScreen extends StatefulWidget {
  CustomerDetailScreen({Key? key, this.idCustomer, this.namaCustomer}) : super(key: key);
  final idCustomer, namaCustomer;

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  late String updateNamaCusotmer;
  late String updateEmailCusotmer;
  late String updateNoHpCusotmer;
  late String updateAlamatCusotmer;

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
                          image: AssetImage('images/customerImageCard.jpg'),
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
                              child: Text(widget.namaCustomer, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),
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
                                        Navigator.pushReplacementNamed(context, CustomerScreen.id);
                                        _authData.updateCustomerDataToDb(
                                          customerId: widget.idCustomer,
                                          namaCustomer: updateNamaCusotmer,
                                          emailCustomer: updateEmailCusotmer,
                                          noHpCustomer: updateNoHpCusotmer,
                                          alamatCustomer: updateAlamatCusotmer,
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
                      stream: _services.firestore.collection('customers').doc(widget.idCustomer).snapshots(),
                      builder: (_, snapshot){
                        if(snapshot.hasError){
                          print('Terdapat masalah');
                        }
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        var data = snapshot.data!.data();
                        var nameCustomer = data!['nama_customer'];
                        var emailCustomer = data['email_customer'];
                        var noHpCustomer = data['no_handpone'];
                        var alamatCustomer = data['alamat_customer'];
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                          child: AbsorbPointer(
                            absorbing: _editing,
                            child: Column(
                              children: [
                                Text(widget.idCustomer, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),),
                                Divider(color: Colors.white70,),
                                SizedBox(height: 15,),

                                TextFormField(
                                  initialValue: nameCustomer,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'masukkan nama customer';
                                    }
                                    setState(() {
                                      updateNamaCusotmer = value;
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
                                    labelText: 'nama customer',
                                    prefixIcon: Icon(Icons.perm_identity, color: Colors.white,),
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                TextFormField(
                                  initialValue: emailCustomer,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'masukkan email customer';
                                    }
                                    setState(() {
                                      updateEmailCusotmer = value;
                                    });
                                    final bool _isValid = EmailValidator.validate(updateEmailCusotmer);
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
                                    labelText: 'email customer',
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                TextFormField(
                                  initialValue: noHpCustomer,
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
                                      updateNoHpCusotmer = value;
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
                                  initialValue: alamatCustomer,
                                  autofocus: false,
                                  onChanged: (value)=>{},
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'masukkan alamat customer';
                                    }
                                    setState(() {
                                      updateAlamatCusotmer = value;
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
                        Navigator.pushReplacementNamed(context, CustomerScreen.id);
                        _services.customer.doc(widget.idCustomer).delete();
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
