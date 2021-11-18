import 'package:cloud_firestore/cloud_firestore.dart';

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
      'imageUrl' : urlImage,
    });
  }

  Future<void> updateCartQty (docId, qty) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('carts').doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Produk tidak ditemukan");
      }

      transaction.update(documentReference, {'unit_produk': qty});

      return qty;
    })
        .then((value) => print("Update Cart"))
        .catchError((error) => print("Gagal update cart: $error"));
  }

  Future<void> removeFormCart(docId) async {
    cart.doc(docId).delete();
  }
}