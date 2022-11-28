import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techor/services/localStorage.dart';

class favourite with ChangeNotifier {
  int counter = 1;
  Icon fav;
  bool isFavourite;

  favourite(this.fav, this.isFavourite);

  void checkFavs(SharedPreferences prefs, final path) {
    final p = prefs.getString('favourites');
    if (p == '' || p == null) {
      // isFavourite = true;

      // return
      isFavourite = false;
      fav = Icon(
        Icons.favorite_border_outlined,
        size: 28,
      );
    } else {
      print('path :   ${path}');
      List data = (json.decode(p.toString()));
      for (var item in data) {
        print('item :  ${item}    knqskn  ');
        if (item['imageUrl'] == path) {
          print('MNOPP');
          isFavourite = true;
          fav = Icon(
            Icons.favorite,
             color: Color(0xFF5956E9),
            size: 28,
          );
        }
        // sum = sum + int.parse(item['price']);
        // products.add(item);
      } // data.map((item) => a.add(data[item]));
    }
    // isFavourite = false;
    // return
    // isFavourite = true;

    // fav = Icon(
    //   Icons.favorite_outline,
    //   size: 28,
    // );

    // List data = (json.decode(p.toString()));
    // for (var item in data) {
    //   print(item);
    // }
    // print('item :  ${item}    knqskn  ');
    // sum = sum + int.parse(item['price']);
    // products.add(item);

    notifyListeners();
  }

  void manageFav(SharedPreferences prefs, final productData) {
    final p = prefs.getString('favourites');
    if (isFavourite) {
      isFavourite = false;
      List data = (json.decode(p.toString()));
      //   // if(data.le)
      // for (var item in data) {
      //   products.add(item);
      // }
      if (data.length > 1) {
        print('123456djshfs');
        List products = [];
        List data = (json.decode(p.toString()));
        for (var item in data) {
          if (item['imageUrl'] == productData['imageUrl']) {
            products.add(item);
          }
        }
        prefs.setString('favourites', json.encode(products));
      } else {
        print('lrngthhhhhhhhh');
        prefs.setString('favourites', '');
      }

      // List data = (json.decode(p.toString()));
    } else {
      isFavourite = true;
      List products = [];
      print('dvcf');
      if (p == '' || p == null) {
        print(productData);
        products.add(productData);
      } else {
        List data = (json.decode(p.toString()));
        for (var item in data) {
          products.add(item);
        }
        products.add(productData);
      }
      print('Pro  : ${products}');
      prefs.setString('favourites', json.encode(products));
    }
  }

  void increaseCount() {
    this.counter++;
    notifyListeners();
  }

  void decreaseCount() {
    this.counter--;
    notifyListeners();
  }
}
