import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot>getAdminCredentials(){
    var result = FirebaseFirestore.instance.collection('admin').get();
    return result;
  }
  
  CollectionReference category = FirebaseFirestore.instance.collection('categorys');
}