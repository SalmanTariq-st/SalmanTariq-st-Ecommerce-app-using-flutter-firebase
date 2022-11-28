// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:techor/screens/basket_screen.dart';
import 'package:techor/screens/favourite_screen.dart';
import 'package:techor/screens/home_screen.dart';
import 'package:techor/screens/intro_screen.dart';
import 'package:techor/screens/prodcut_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

int? a;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await Hive.initFlutter();
  var box = await Hive.openBox('products');
  a = prefs.getInt('counter');
  prefs.setInt('counter', 1);
  // prefs.setString('product', '');
  // prefs.setString('favourites', '');
  // a == null ? print('null') : print('yes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          ),
      // home: introScreen(),
      initialRoute: a == null || a == 0 ? '/intro' : '/homePage',

      routes: {
        '/homePage': (context) => KFDrawerRun(),
      
        '/intro': (context) => introScreen(),
        '/basket': (context) => basket(),
        '/favourite': (context) => favouriteScreen(),
        '/productView': (context) => product()
        // '/searchbar':(context) => searchBar()
      },
    );
  }
}
