import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/services/cart_service.dart';
import 'package:point_of_sale/widgets/add_cart/add_to_cart_button_detail.dart';

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot <Map<String, dynamic>> document;

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  CartService _cart = CartService();

  bool _loading = true;
  bool _exists = false;
  int _qty = 1;
  late int _qtyProd;
  late String _docId;//id_keranjang

  void initState() {
    getCartData();
    _qtyProd = widget.document.data()!['stok_produk'];
    super.initState();
  }

  getCartData() async {
    final snapshot = await _cart.cart.get();
    if (snapshot.docs.length == 0){
      setState(() {
        _loading = false;
      });
    }else{
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance.collection('carts').
    where('id_produk', isEqualTo: widget.document.data()!['id_produk']).get().
    then((QuerySnapshot querySnapshot)=>{
      querySnapshot.docs.forEach((doc) {
        if(doc['id_produk'] == widget.document.data()!['id_produk']){
          setState(() {
            _exists = true;
            _qty = doc['unit_produk'];
            _docId = doc['id_keranjang'];
          });
        }
      })
    });

    return _loading ? Container( //LOADING MENEMUKAN CART
      height: 45,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),  // radius of 10
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0, left: 12.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    ) : _exists ? Container( //JIKA SUDAH ADA DI CART
      height: 45,
      width: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),  // radius of 10
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CounterWidget(
            document: widget.document, qty: _qty, docId: _docId,
          ),
        ],
      ),
    ) : TextButton.icon(//JIKA TIDAK ADA DI CART
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: EdgeInsets.only(right: 12.0, left: 12, bottom: 8, top: 8),
      ),
      icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.blue, size: 30,),
      label: Text('Tambah', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),),
      onPressed: (){
        setState(() {
          _qtyProd--;
        });
        EasyLoading.show(status: 'Menyimpan...');
        _cart.addToCart(
          idProduk : widget.document.data()!['id_produk'],
          kodeProduk : widget.document.data()!['kode_produk'],
          namaProduk : widget.document.data()!['nama_produk'],
          hargaProduk : double.parse(widget.document.data()!['harga_produk'].toString()),
          urlImage : widget.document.data()!['imageUrl'],
          ketProduk: widget.document.data()!['ket_produk'],
        ).then((value){
          setState(() {
            _loading = true;
          });
        }).then((value){
          setState(() {
            _loading = false;
          });
          EasyLoading.showSuccess('Berhasil');
        });
        _cart.updateProdukQty(
          widget.document.data()!['id_produk'],
          _qtyProd,
        );
      },
    );
  }
}
