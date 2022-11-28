// ignore_for_file: unused_import, file_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: camel_case_types
class productsData {
  List products = [];

  final box = Hive.box('products');

  void loadData() {
    products = box.get('products');
  }

  void createInitialData() {
    products = [];
  }

  void updateDatabase() {
    box.put('products', products);
    // box.add(products);
  }
}
