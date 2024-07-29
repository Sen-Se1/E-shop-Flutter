import 'package:e_comerce/helper/helper_function.dart';
import 'package:e_comerce/pages/auth/login.dart';
import 'package:e_comerce/pages/checkout.dart';
import 'package:e_comerce/pages/navBar.dart';
import 'package:e_comerce/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId,
      storageBucket: Constants.storageBucket,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CartModel(),
        child: MaterialApp(
          theme: ThemeData(
              primaryColor: Constants().primaryColor,
              scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          home:
              // AddProductPage()
              _isSignedIn ? const NavbarPage() : const LoginPage(),
        ));
  }
}
