import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sale/screens/customer_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/category_screen.dart';
import 'package:point_of_sale/screens/login2_screen.dart';
import 'package:point_of_sale/screens/login_screen.dart';
import 'package:point_of_sale/screens/order_screen.dart';
import 'package:point_of_sale/screens/pos_screen.dart';
import 'package:point_of_sale/screens/produk_screen.dart';
import 'package:point_of_sale/screens/suplier_screen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final padding_menu = EdgeInsets.symmetric(horizontal: 20);
    return Drawer(
      child: Material(
        color: Color(0xff363636),
        child: ListView(
          padding: padding_menu,
          children: <Widget> [
            const SizedBox(height: 30,),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Image.asset('images/pokdakan.png', height: 50,),
                ),
                Column(
                  children: [
                    Text(
                      'POS Pokdakan',
                      style: GoogleFonts.patuaOne(
                        color: Colors.white,
                        fontSize: 21,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'PT. Pokdakan Mitra Bersama',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Divider(color: Colors.white70,),
            buildMenuItems(
              text: 'Beranda',
              icon: Icons.home_filled,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, HomeScreen.id);
              },
              //onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItems(
              text: 'Customer',
              icon: Icons.people,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, CustomerScreen.id);
              },
              //onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItems(
              text: 'Supliers',
              icon: Icons.clean_hands,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, SuplierScreen.id);
              },
            ),
            buildMenuItems(
              text: 'Produk',
              icon: Icons.card_travel,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, ProdukScreen.id);
              },
            ),
            const SizedBox(height: 10,),
            buildMenuItems(
              text: 'POS Sistem',
              icon: Icons.card_membership_sharp,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, PosScreen.id);
              },
            ),
            buildMenuItems(
              text: 'Orders',
              icon: Icons.assignment,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, OrderScreen.id);
              },
            ),
            buildMenuItems(
              text: 'Category',
              icon: Icons.category,
              onClicked: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, CategoryScreen.id);
              },
            ),
            Divider(color: Colors.white70,),
            buildMenuItems(
              text: 'Keluar',
              icon: Icons.power_settings_new,
              onClicked: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, Login2Screen.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItems({required String text, required IconData icon, VoidCallback? onClicked}){
    final color = Colors.white;
    final hoverColor = Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color,),
      title: Text(text, style: TextStyle(color: color),),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

/*  void selectedItem(BuildContext context, int index) {
    switch (index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CustomerScreen(),
        ),);
        break;
    }
  }*/
}
