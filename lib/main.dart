import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sale/providers/auth_provider.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/login_screen.dart';
import 'package:point_of_sale/screens/register_screen.dart';
import 'package:point_of_sale/screens/reset_pw_screen.dart';
import 'package:point_of_sale/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider())
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
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id : (context) => SplashScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        RegisterScreen.id : (context) => RegisterScreen(),
        LoginScreen.id : (context) => LoginScreen(),
        ResetPassword.id : (context) => ResetPassword(),
      },
    );
  }
}
