import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService{
  CollectionReference cart = FirebaseFirestore.instance.collection('carts');

  Future<void> addToCart ({idProduk, kodeProduk, namaProduk, hargaProduk, urlImage}) async {
    var timeStamp = new DateTime.now().microsecondsSinceEpoch;
    cart.doc('CART-'+timeStamp.toString()).set({
      'id_keranjang' : 'CART-'+timeStamp.toString(),
      'waktu_cart' : FieldValue.serverTimestamp(),
      'id_produk' : idProduk,
      'kode_produk' : kodeProduk,
      'nama_produk' : namaProduk,
      'harga_produk' : hargaProduk,
      'unit_produk' : 1,
      'total_harga' : hargaProduk,
      'imageUrl' : urlImage,
    });
  }

  Future<void> updateCartQty (docId, qty, total_harga) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('carts').doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Produk tidak ditemukan");
      }

      transaction.update(documentReference, {
        'unit_produk': qty,
        'total_harga' : total_harga,
      });

      return qty;
    })
        .then((value) => print("Update Cart"))
        .catchError((error) => print("Gagal update cart: $error"));
  }

  Future<void> removeFormCart(docId) async {
    cart.doc(docId).delete();
  }

  Future<DocumentSnapshot> getShopData() async {
    User user = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot doc = await cart.doc(user.uid).get();
    return doc;
  }

}