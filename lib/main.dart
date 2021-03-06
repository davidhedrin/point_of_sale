import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/providers/cart_provider.dart';
import 'package:point_of_sale/screens/add/addCategory_screen.dart';
import 'package:point_of_sale/screens/add/addCustomer_screen.dart';
import 'package:point_of_sale/screens/add/addPosCart_screen.dart';
import 'package:point_of_sale/screens/add/addProduk_screen.dart';
import 'package:point_of_sale/screens/add/addSuplier_screen.dart';
import 'package:point_of_sale/screens/customer_screen.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/category_screen.dart';
import 'package:point_of_sale/screens/login2_screen.dart';
import 'package:point_of_sale/screens/login_screen.dart';
import 'package:point_of_sale/screens/order_screen.dart';
import 'package:point_of_sale/screens/pos_screen.dart';
import 'package:point_of_sale/screens/produk_screen.dart';
import 'package:point_of_sale/screens/register_admin_screen.dart';
import 'package:point_of_sale/screens/register_email_screen.dart';
import 'package:point_of_sale/screens/reset_pw_admin_screen.dart';
import 'package:point_of_sale/screens/reset_pw_screen.dart';
import 'package:point_of_sale/screens/show_password_screen.dart';
import 'package:point_of_sale/screens/splash_screen.dart';
import 'package:point_of_sale/screens/suplier_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id : (context) => SplashScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        RegisterAdminScreen.id : (context) => RegisterAdminScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        Login2Screen.id : (context) => Login2Screen(),
        ResetPassword.id : (context) => ResetPassword(),
        ResetPasswordAdmin.id : (context) => ResetPasswordAdmin(),
        CustomerScreen.id : (context) => CustomerScreen(),
        SuplierScreen.id : (context) => SuplierScreen(),
        ProdukScreen.id : (context) => ProdukScreen(),
        PosScreen.id : (context) => PosScreen(),
        OrderScreen.id : (context) => OrderScreen(),
        CategoryScreen.id : (context) => CategoryScreen(),
        AddCustomerData.id : (context) => AddCustomerData(),
        AddSuplierData.id : (context) => AddSuplierData(),
        AddProdukData.id : (context) => AddProdukData(),
        AddPosCartScreen.id : (context) => AddPosCartScreen(),
        AddCategoryScreen.id : (context) => AddCategoryScreen(),
        ShowForgotePassword.id : (context) => ShowForgotePassword(),
      },
    );
  }
}
