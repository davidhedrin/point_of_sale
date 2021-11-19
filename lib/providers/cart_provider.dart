import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{
  Future<QuerySnapshot>getAdminCredentials(){
    var result = FirebaseFirestore.instance.collection('carts').get();
    return result;
  }

  double subTotal = 0.0;
  int cartQty = 0;
  QuerySnapshot? snapshot;

  Future<double> getCartTotal() async {
    var cartTotal = 0.0;

    QuerySnapshot snapshot = await getAdminCredentials();
    if(snapshot == null){
      return null!;
    }

    snapshot.docs.forEach((doc) {
      cartTotal = cartTotal + doc.get('total_harga');
    });

    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }
}
