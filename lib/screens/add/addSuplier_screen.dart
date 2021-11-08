import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/suplier_screen.dart';
import 'package:provider/provider.dart';

class AddSuplierData extends StatefulWidget {
  const AddSuplierData({Key? key}) : super(key: key);

  static const String id = 'addsuplier-screen';

  @override
  _AddSuplierDataState createState() => _AddSuplierDataState();
}

class _AddSuplierDataState extends State<AddSuplierData> {
  final _formKey = GlobalKey<FormState>();

  var _ketSuplierTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  late String namaSuplier;
  late String emailSuplier;
  late String mobileSuplier;
  late String alamatSuplier;

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
          title: Text('Tambah Suplier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Image.asset('images/suplierAdd.png', height: 135,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //nama suplier
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
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
                            color: Colors.white,
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
                      ),
                      SizedBox(height: 10,),

                      //email suplier
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
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
                            color: Colors.white,
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
                      ),
                      SizedBox(height: 10,),

                      //no ho suplier
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
                              mobileSuplier = '+62' + value;
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
                      SizedBox(height: 10,),

                      //alamat suplier
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
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
                            color: Colors.white,
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
                      ),
                      SizedBox(height: 10,),

                      //komentar suplier
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          controller: _ketSuplierTextController,
                          validator: (value){
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
                            prefixIcon: Icon(Icons.comment,),
                            labelText: 'komentar',
                            labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      //tombol simpan
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

                      //tanda *
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
          Image.asset('images/suplier.png', height: 60,),
          SizedBox(height: 10,),
          Text(
            'Tambahkan Suplier Baru!',
            style: TextStyle(fontSize: 19),
          ),
        ],
      ),
      content: Text(
        'Apakah data Suplier sudah benar?',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('batal'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text('iya'),
          onPressed: (){
            Navigator.pushReplacementNamed(context, SuplierScreen.id);
            _authData.saveSuplierDataToDb(
              context: context,
              namaSuplier: namaSuplier,
              emailSuplier: _emailTextController.text,
              noHpSuplier: mobileSuplier,
              alamatSuplier: alamatSuplier,
              komentar: _ketSuplierTextController.text,
            );
          },
        ),
      ],
    );
  }
}
