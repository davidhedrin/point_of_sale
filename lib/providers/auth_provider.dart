import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_of_sale/providers/cart_provider.dart';
import 'package:point_of_sale/screens/add/addCategory_screen.dart';
import 'package:point_of_sale/screens/add/addCustomer_screen.dart';
import 'package:point_of_sale/screens/add/addProduk_screen.dart';
import 'package:point_of_sale/screens/add/addSuplier_screen.dart';
import 'package:point_of_sale/services/cart_service.dart';

class AuthProvider extends ChangeNotifier{

  CartService _cart = CartService();

  String error = '';
  String email = '';
  bool isPickAvail = false;

  late File image;
  String pickerError = '';
  String? id_Category, selectedCategory;
  String? id_Suplier, selectedSuplier;

  selectCategory(selected, id_Category){
    this.selectedCategory = selected;
    this.id_Category = id_Category;
    notifyListeners();
  }
  selectSuplier(selected, id_Suplier){
    this.selectedSuplier = selected;
    this.id_Suplier = id_Suplier;
    notifyListeners();
  }

  removeProvider(){
    this.id_Category=null;
    this.selectedCategory=null;
    this.id_Suplier=null;
    this.selectedSuplier=null;
    notifyListeners();
  }

  //register admin email
  Future<UserCredential> registerAdmin(email, password) async {
    late UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      print(e);
    }
    return userCredential;
  }
  //login admin email
  Future<UserCredential?> loginAdmin(email, password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
    return userCredential;
  }
  //reset password email
  Future<void> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }


  //upload image
  Future<File> getImage() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null){
      this.image = File(pickedFile.path);
      notifyListeners();
    }else{
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        actions: [
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }

  //save category to database
  Future<void>? saveCategoryDataToDb({url, category, context}) {
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    CollectionReference _category = FirebaseFirestore.instance.collection('categorys');
    try{
      _category.doc('CAT-'+timeStamp.toString()).set({
        'category_id' : 'CAT-'+timeStamp.toString(),
        'category' : category,
        'imageUrl' : url,
      });
      this.alertDialogCategory(
        context: context,
        title: 'Simpan Category',
        content: 'Category baru berhasil ditambahkan',
      );
    }catch(e){
      this.alertDialog(
        title: 'Simpan Produk',
        content: '${e.toString()}',
      );
    }
    return null;
  }
  alertDialogCategory({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        actions: [
          CupertinoDialogAction(child: Text('Lagi'), onPressed: () => Navigator.pushReplacementNamed(context, AddCategoryScreen.id),),
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }

  //upload produk image to firebase storeage
  Future<String> uploadProdukImage(filePath, namaProduk) async {
    File file = File(filePath);
    FirebaseStorage _storage = FirebaseStorage.instance;

    var timeStamp = new DateTime.now().microsecondsSinceEpoch;

    try {
      await _storage.ref('produkImage/$namaProduk$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    //upload url link to database
    String downloadURL = await _storage.ref('produkImage/$namaProduk$timeStamp').getDownloadURL();

    return downloadURL;
  }

  //save produk to firebase
  Future<void>? saveProdukDataToDb({url, namaProduk, hargaProduk, codeProduk, stokProduk, ketProduk, context}){
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    CollectionReference _produk = FirebaseFirestore.instance.collection('produks');
    try{
      _produk.doc('PO-'+timeStamp.toString()).set({
        'id_produk' : 'PO-'+timeStamp.toString(),
        'suplier_produk' : {'nama_suplier' : this.selectedSuplier, 'id_suplier' : this.id_Suplier},
        'nama_produk' : namaProduk,
        'category_produk' : {'nama_category' : this.selectedCategory, 'id_category' : this.id_Category},
        'harga_produk' :  hargaProduk,
        'kode_produk' : codeProduk,
        'stok_produk' : stokProduk,
        'ket_produk' : ketProduk,
        'imageUrl' : url,

      });
      this.alertDialogProduk(
        context: context,
        title: 'Simpan Produk',
        content: 'Produk baru berhasil ditambahkan',
      );
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'Simpan Produk',
        content: '${e.toString()}',
      );
    }
    return null;
  }
  Future<void>? updateProdukDataToDb({idProduk, image, namaProduk, hargaProduk, stokProduk, ketProduk, context, namaSupProduk, idSup, namaCatProduk, idCat}){
    CollectionReference _produk = FirebaseFirestore.instance.collection('produks');
    try{
      _produk.doc(idProduk).update({
        'suplier_produk' : {'nama_suplier' : this.selectedSuplier == null ? namaSupProduk : this.selectedSuplier, 'id_suplier' : this.id_Suplier == null ? idSup : this.id_Suplier},
        'nama_produk' : namaProduk,
        'category_produk' : {'nama_category' : this.selectedCategory == null ? namaCatProduk : this.selectedCategory, 'id_category' : this.id_Category == null ? idCat : this.id_Category},
        'harga_produk' :  hargaProduk,
        'stok_produk' : stokProduk,
        'ket_produk' : ketProduk,
        'imageUrl' : image,
      });
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'Simpan Produk',
        content: '${e.toString()}',
      );
    }
    return null;
  }
  alertDialogProduk({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        actions: [
          CupertinoDialogAction(child: Text('Lagi'), onPressed: () => Navigator.pushReplacementNamed(context, AddProdukData.id),),
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }

  //save suplier to database
  Future<void> saveSuplierDataToDb({namaSuplier, emailSuplier, noHpSuplier, alamatSuplier, komentar, context}) async {
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    CollectionReference _suplier = FirebaseFirestore.instance.collection('supliers');
    try{
      _suplier.doc('SUP-'+timeStamp.toString()).set({
        'id_suplier' : 'SUP-'+timeStamp.toString(),
        'nama_suplier' : namaSuplier,
        'email_suplier' : emailSuplier,
        'no_handpone' : noHpSuplier,
        'alamat_suplier' : alamatSuplier,
        'komentar' : komentar,
      });
      this.alertDialogSuplier(
        context: context,
        title: 'Simpan Suplier',
        content: 'Suplier baru berhasil ditambahkan',
      );
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'Simpan Suplier',
        content: '${e.toString()}',
      );
    }
  }
  Future<void>? updateSuplierDataToDb({namaSuplier, emailSuplier, noHpSuplier, alamatSuplier, komentar, context, suplierId}){
    CollectionReference _suplierUpdate = FirebaseFirestore.instance.collection('supliers');
    try{
      _suplierUpdate.doc(suplierId).update({
        'nama_suplier' : namaSuplier,
        'email_suplier' : emailSuplier,
        'no_handpone' : noHpSuplier,
        'alamat_suplier' : alamatSuplier,
        'komentar' : komentar
      });
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'Update Customer',
        content: '${e.toString()}',
      );
    }
  }
  alertDialogSuplier({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        actions: [
          CupertinoDialogAction(child: Text('Lagi'), onPressed: () => Navigator.pushReplacementNamed(context, AddSuplierData.id),),
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }

  //save customer to database
  Future<void> saveCustomerDataToDb({namaCustomer, emailCustomer, noHpCustomer, alamatCustomer, context}) async {
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    CollectionReference _customer = FirebaseFirestore.instance.collection('customers');
    try{
      _customer.doc('COS-'+timeStamp.toString()).set({
        'id_customer' : 'COS-'+timeStamp.toString(),
        'nama_customer' : namaCustomer,
        'email_customer' : emailCustomer,
        'no_handpone' : noHpCustomer,
        'alamat_customer' : alamatCustomer,
      });
      this.alertDialogCustomer(
        context: context,
        title: 'Simpan Customer',
        content: 'Customer baru berhasil ditambahkan',
      );
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'Simpan Customer',
        content: '${e.toString()}',
      );
    }
  }
  Future<void>? updateCustomerDataToDb({namaCustomer, emailCustomer, noHpCustomer, alamatCustomer, context, customerId}){
    CollectionReference _customerUpdate = FirebaseFirestore.instance.collection('customers');
    try{
      _customerUpdate.doc(customerId).update({
        'nama_customer' : namaCustomer,
        'email_customer' : emailCustomer,
        'no_handpone' : noHpCustomer,
        'alamat_customer' : alamatCustomer,
      });
    }catch(e){
      this.alertDialog(
        context: context,
        title: 'Update Customer',
        content: '${e.toString()}',
      );
    }
  }
  alertDialogCustomer({context, title, content}){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
        actions: [
          CupertinoDialogAction(child: Text('Lagi'), onPressed: () => Navigator.pushReplacementNamed(context, AddCustomerData.id),),
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }


  //save keranjang ke transaksi dan kirim ke Cart Service
  String? id_Customer, selectedCustomer;
  selectCustomer(selected, id_Customer){
    this.selectedCustomer = selected;
    this.id_Customer = id_Customer;
    notifyListeners();
  }
  saveOrderToDbTrans(CartProvider cartProvider, subToHarga, metoBayar, metoKirim){
    _cart.saveCartToTransDb({
      'produks' : cartProvider.cartList,
      'sub_total_harga' :subToHarga,
      'customer' : {'nama_cutomer' : this.selectedCustomer, 'id_customer' : this.id_Customer},
      'namaCustomer' : this.selectedCustomer,
      'metode_bayar' : metoBayar,
      'metode_kirim' : metoKirim,
      'waktu_trans' : DateTime.now().toString(),
    });
  }
}