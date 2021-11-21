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
  List cartList = [] as dynamic;

  Future<double> getCartTotal() async {
    var cartTotal = 0.0;
    List _newList = [];

    QuerySnapshot snapshot = await getAdminCredentials();
    if(snapshot == null){
      return null!;
    }

    snapshot.docs.forEach((doc) {
      if(!_newList.contains(doc.data())){
        _newList.add(doc.data());
        this.cartList = _newList;
        notifyListeners();
      }

      cartTotal = cartTotal + doc.get('total_harga');
    });

    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }
}
