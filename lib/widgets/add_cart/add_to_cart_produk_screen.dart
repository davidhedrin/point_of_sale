import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/services/cart_service.dart';

class AddToCartProdukScreen extends StatefulWidget {
  const AddToCartProdukScreen({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot <Map<String, dynamic>> document;

  @override
  State<AddToCartProdukScreen> createState() => _AddToCartProdukScreenState();
}

class _AddToCartProdukScreenState extends State<AddToCartProdukScreen> {
  CartService _cart = CartService();

  int _qty = 1;
  late int _qtyProd;
  bool _exists = false;
  bool _updateing = false;
  late String _docId;//id_keranjang

  @override
  void initState() {
    getCartData();
    _qtyProd = widget.document.data()!['stok_produk'];
    super.initState();
  }

  getCartData(){
    FirebaseFirestore.instance.collection('carts').
    where('id_produk', isEqualTo: widget.document.data()!['id_produk']).get().
    then((QuerySnapshot querySnapshot)=>{
      if(querySnapshot.docs.isNotEmpty){
        querySnapshot.docs.forEach((doc) {
          if(doc['id_produk'] == widget.document.data()!['id_produk']){
            setState(() {
              _exists = true;
              _qty = doc['unit_produk'];
              _docId = doc['id_keranjang'];
            });
          }
        })
      }else{
        setState(() {
          _exists = false;
        })
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return _exists ? StreamBuilder(
      stream: getCartData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic>snapshot){
        return Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  child: _qty == 1 ? Icon(
                    Icons.delete_forever, color: Colors.red, size: 27,
                  ) : Icon(Icons.remove_circle_outline, color: Colors.blue,),
                  onTap: (){
                    setState(() {
                      _updateing = true;
                    });
                    if(_qty == 1){
                      setState(() {
                        _qtyProd++;
                      });
                      _cart.removeFormCart(_docId).then((value){
                        _updateing = false;
                        _exists = false;
                      });
                      _cart.updateProdukQty(
                        widget.document.data()!['id_produk'],
                        _qtyProd,
                      );
                    }
                    if(_qty > 1){
                      setState(() {
                        _qty--;
                        _qtyProd++;
                      });
                      var _total = _qty * widget.document.data()!['harga_produk'];
                      _cart.updateCartQty(
                        _docId,
                        _qty,
                        _total,
                      ).then((value){
                        setState(() {
                          _updateing = false;
                        });
                      });

                      _cart.updateProdukQty(
                        widget.document.data()!['id_produk'],
                        _qtyProd,
                      );
                    }
                  },
                ),
              ),

              _updateing ? Center(
                child: SizedBox(
                  width: 29,
                  height: 29,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ) : Text(
                _qty.toString(),
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 23),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: InkWell(
                  child: Icon(Icons.add_circle_outline, color: Colors.blue,),
                  onTap: (){
                    setState(() {
                      _updateing = true;
                      _qty++;
                      _qtyProd--;
                    });
                    var _total = _qty * widget.document.data()!['harga_produk'];
                    _cart.updateCartQty(
                      _docId,
                      _qty,
                      _total,
                    ).then((value){
                      setState(() {
                        _updateing = false;
                      });
                    });

                    _cart.updateProdukQty(
                      widget.document.data()!['id_produk'],
                      _qtyProd,
                    );

                  },
                ),
              ),
            ],
          ),
        );
      }) : StreamBuilder(
      stream: getCartData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic>snapshot){
        return InkWell(
          onTap: (){
            setState(() {
              _qtyProd--;
            });
            EasyLoading.show(status: 'Menyimpan...');
            _cart.addToCart(
              idCart: Random().nextInt(90000) + 10000,
              idProduk : widget.document.data()!['id_produk'],
              kodeProduk : widget.document.data()!['kode_produk'],
              namaProduk : widget.document.data()!['nama_produk'],
              hargaProduk : double.parse(widget.document.data()!['harga_produk'].toString()),
              urlImage : widget.document.data()!['imageUrl'],
              ketProduk: widget.document.data()!['ket_produk'],
            ).then((value){
              EasyLoading.showSuccess('Berhasil');
              setState(() {
                _exists = true;
              });
            });

            _cart.updateProdukQty(
              widget.document.data()!['id_produk'],
              _qtyProd,
            );
          },
          child: Row(
            children: [
              Icon(Icons.add_shopping_cart_rounded, color: Colors.blue, size: 25,),
              Text('Tambah', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),),
            ],
          ),
        );
      },
    );
  }
}
