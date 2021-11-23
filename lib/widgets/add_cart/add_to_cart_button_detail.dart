import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/services/cart_service.dart';
import 'package:point_of_sale/widgets/add_cart/add_to_cart_detail_widget.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key, required this.document, this.qty, required this.docId}) : super(key: key);
  final DocumentSnapshot<Map<String, dynamic>> document;
  final int? qty;
  final String docId;

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  CartService _cart = CartService();
  late int _qty;
  late int _qtyProd;
  late String _produkId;//id_keranjang

  bool _updateing = false;
  bool _exists = true;

  @override
  Widget build(BuildContext context) {
    setState(() {
      _qty = widget.qty!;
      _qtyProd = widget.document.data()!['stok_produk'];
      _produkId = widget.document.id;
    });

    return _exists ? Container(
      height: 56,
      child: Center(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
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
                    _cart.removeFormCart(widget.docId).then((value){
                      _updateing = false;
                      _exists = false;
                    });
                    _cart.updateProdukQty(
                      _produkId,
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
                      widget.docId,
                      _qty,
                      _total,
                    ).then((value){
                      setState(() {
                        _updateing = false;
                      });
                    });

                    _cart.updateProdukQty(
                      _produkId,
                      _qtyProd,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _updateing ? Container(
                height: 24, width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ) : Text(_qty.toString(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 23),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
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
                    widget.docId,
                    _qty,
                    _total,
                  ).then((value){
                    setState(() {
                      _updateing = false;
                    });
                  });

                  _cart.updateProdukQty(
                    _produkId,
                    _qtyProd,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ) : AddToCartWidget(document: (widget.document as dynamic));
  }
}
