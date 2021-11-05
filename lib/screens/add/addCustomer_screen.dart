import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/customer_screen.dart';
import 'package:provider/provider.dart';

class AddCustomerData extends StatefulWidget {
  const AddCustomerData({Key? key}) : super(key: key);

  static const String id = 'addcustomer-screen';

  @override
  _AddCustomerDataState createState() => _AddCustomerDataState();
}

class _AddCustomerDataState extends State<AddCustomerData> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  late String namaCustomer;
  late String mobileCustomer;
  late String alamatCustomer;

  @override
  Widget build(BuildContext context) {
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
          title: Text('Tambah Customer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
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
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset('images/customerAdd.png', height: 115,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan nama customer';
                            }
                            setState(() {
                              namaCustomer = value;
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
                            prefixIcon: Icon(Icons.perm_identity,),
                            labelText: '*nama customer',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan email customer';
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.email_rounded,),
                            labelText: '*email customer',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
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
                              mobileCustomer = value;
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
                            prefixIcon: Icon(Icons.phone_android,),
                            labelText: '*no telepon',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return 'masukkan alamat customer';
                            }
                            setState(() {
                              alamatCustomer = value;
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
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Icon(Icons.location_on_outlined,),
                            labelText: '*alamat customer',
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
                                if(_formKey.currentState!.validate()){
                                  showCupertinoDialog(
                                    context: context,
                                    builder: createDialogConfirmation,
                                  );
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('tanda * wajib diisi', style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),),
                        ],
                      ),
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
          Image.asset('images/customer.png', height: 60,),
          SizedBox(height: 10,),
          Text(
            'Tambah Customer Baru!',
            style: TextStyle(fontSize: 19),
          ),
        ],
      ),
      content: Text(
        'Apakah data Customer sudah benar?',
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
            Navigator.pushReplacementNamed(context, CustomerScreen.id);
            EasyLoading.dismiss();
            _authData.saveCustomerDataToDb(
              context: context,
              namaCustomer: namaCustomer,
              emailCustomer: _emailTextController.text,
              noHpCustomer: mobileCustomer,
              alamatCustomer: alamatCustomer,
            );
          },
        ),
      ],
    );
  }
}