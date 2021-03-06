import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CartService{
  CollectionReference cart = FirebaseFirestore.instance.collection('carts');
  CollectionReference trans = FirebaseFirestore.instance.collection('transaksis');
  FirebaseFirestore firestoreTrans = FirebaseFirestore.instance;

  Future<void> addToCart ({idCart, idProduk, kodeProduk, namaProduk, hargaProduk, urlImage, ketProduk}) async {
    var idTime = '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}';
    cart.doc('CART-'+idTime+idCart.toString()).set({
      'id_keranjang' : 'CART-'+idTime+idCart.toString(),
      'waktu_cart' : FieldValue.serverTimestamp(),
      'id_produk' : idProduk,
      'kode_produk' : kodeProduk,
      'nama_produk' : namaProduk,
      'harga_produk' : hargaProduk,
      'unit_produk' : 1,
      'total_harga' : hargaProduk,
      'imageUrl' : urlImage,
      'ket_produk' : ketProduk,
    });
  }

  Future<void> updateProdukQty (docId, qty) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection('produks').doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Produk tidak ditemukan");
      }

      transaction.update(documentReference, {
        'stok_produk': qty,
      });

      return qty;
    })
        .then((value) => print("Update Cart"))
        .catchError((error) => print("Gagal update cart: $error"));
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
  Future<void> removeCart() async {
    final result = await cart.get().then((snapshot){
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  //simpan transaksi baru ke tb transaksis
  Future<DocumentReference>? saveCartToTransDb(Map<String, dynamic>data){
    var idTime = '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}';
    int? numberRan = Random().nextInt(90000) + 10000;
    trans.doc('TRAS-'+idTime+numberRan.toString()).set(data);
  }

}