import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier{
  String error = '';
  String email = '';
  late File image;
  String pickerError = '';
  bool isPickAvail = false;

  String selectedCategory = 'belum dipilih';
  String selectedSuplier = 'belum dipilih';

  selectCategory(selected){
    this.selectedCategory = selected;
    notifyListeners();
  }
  selectSuplier(selected){
    this.selectedSuplier = selected;
    notifyListeners();
  }
/*  getNamaProduk(namaProduk){
    this.namaProduk = namaProduk;
    notifyListeners();
  }*/

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

  //login admin
  Future<UserCredential?> loginVendor(email, password) async {
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

  //reset password
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
        content: Text(content),
        actions: [
          CupertinoDialogAction(child: Text('Ok'), onPressed: () => Navigator.pop(context),),
        ],
      );
    });
  }

  //save category to database
  Future<void>? saveCategoryDataToDb({url, category}) {
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    CollectionReference _category = FirebaseFirestore.instance.collection('categorys');
    try{
      _category.doc(timeStamp.toString()).set({
        'category_id' : timeStamp.toString(),
        'category' : category,
        'imageUrl' : url,
      });
      this.alertDialog(
        title: 'Success',
        content: 'Produk berhasil ditambahkan.',
      );
    }catch(e){
      this.alertDialog(
        title: 'Success',
        content: '${e.toString()}',
      );
    }
    return null;
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
  Future<void>? saveProdukDataToDb({url, namaProduk, hargaProduk, codeProduk, stokProduk, ketProduk,}){
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    CollectionReference _produk = FirebaseFirestore.instance.collection('produks');
    try{
      _produk.doc(timeStamp.toString()).set({
        'id_produk' : timeStamp.toString(),
        'nama_produk' : namaProduk,
        'category_produk' : this.selectedCategory,
        'harga_produk' :  hargaProduk,
        'kode_produk' : codeProduk,
        'stok_produk' : stokProduk,
        'ket_produk' : ketProduk,
        'imageUrl' : url,
      });
      this.alertDialog(
        title: 'Simpan Produk',
        content: 'Produk baru berhasil ditambahkan',
      );
    }catch(e){
      this.alertDialog(
        title: 'Simpan Produk',
        content: '${e.toString()}',
      );
    }
    return null;
  }
}