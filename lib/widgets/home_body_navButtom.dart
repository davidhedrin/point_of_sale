import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/screens/customer_screen.dart';
import 'package:point_of_sale/screens/category_screen.dart';
import 'package:point_of_sale/screens/order_screen.dart';
import 'package:point_of_sale/screens/pos_screen.dart';
import 'package:point_of_sale/screens/produk_screen.dart';
import 'package:point_of_sale/screens/suplier_screen.dart';

class BodyHomeMenu extends StatefulWidget {
  const BodyHomeMenu({Key? key}) : super(key: key);

  @override
  _BodyHomeMenuState createState() => _BodyHomeMenuState();
}

class _BodyHomeMenuState extends State<BodyHomeMenu> {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff363636),
      body: Stack(
        children: <Widget> [
          //header POS Pokdakan PT. Pokdakan
          Container(
            color: Color(0xff363636),
            child: Column(
              children: <Widget> [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Container(
                      height: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget> [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage('images/pokdakan.png')),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget> [
                              Text(
                                'POS Pokdakan',
                                style: GoogleFonts.patuaOne(
                                  color: Colors.white,
                                  fontSize: 30,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'PT. Pokdakan Mitra Bersama',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          //backgroud putih
          Padding(
            padding: const EdgeInsets.only(top: 170),
            child: Container(
              height: _height * 0.70,
              width: _width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
              ),
            ),
          ),

          //fitur customer, suplier, produk, POS, all order, & In/Out
          Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 120.0),
            child: Container(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget> [

                  //Client dan supliers
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff8E8585),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('images/customer.png')),
                                    ),
                                  ),
                                ),
                                Text('Customer', style: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, CustomerScreen.id);
                            },
                          ),
                        ),
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff8E8585),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('images/suplier.png')),
                                    ),
                                  ),
                                ),
                                Text('Supliers', style: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, SuplierScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  //produk dan pos
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff8E8585),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('images/produk.png')),
                                    ),
                                  ),
                                ),
                                Text('Produk', style: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, ProdukScreen.id);
                            },
                          ),
                        ),
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff8E8585),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('images/category.png')),
                                    ),
                                  ),
                                ),
                                Text('Kategori', style: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, CategoryScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  //all order and kategory
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff8E8585),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('images/order.png')),
                                    ),
                                  ),
                                ),
                                Text('All Orders', style: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, OrderScreen.id);
                            },
                          ),
                        ),
                        Container(
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff8E8585),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Column(
                              children: <Widget> [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: AssetImage('images/pos.png')),
                                    ),
                                  ),
                                ),
                                Text('POS', style: GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black),),
                              ],
                            ),
                            onPressed: (){
                              Navigator.pushNamed(context, PosScreen.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
