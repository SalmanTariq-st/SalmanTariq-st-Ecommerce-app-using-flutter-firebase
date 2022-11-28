// ignore: file_names
// ignore_for_file: file_names, unused_import, duplicate_ignore, camel_case_types, avoid_print, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Storage {
  List docIDs = [];
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult results =
        await storage.ref('wearable').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      // print('found file : $ref');
    });
    return results;
  }

  Future<String> downloadURL(String imagePath) async {
    String downloadURL = await storage.ref('$imagePath').getDownloadURL();
    // print(downloadURL);
    return downloadURL;
  }

  String getId() {
    getDocId();

    return docIDs[0];
  }

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('productDetails')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));

    // print(docIDs[0].get('title'));
    return docIDs;
  }
}
// Reference get _firebaseStorage => FirebaseStorage.instance.ref();
// final storageRef = FirebaseStorage.instance.ref();
// class firebaseStorage extends GetxService {
//   List imgUrls = [];

//   Future<String?> getImg(String? img) async {
//     if (img == null) {
//       print('not found');

//       return 'https://i.pinimg.com/originals/42/11/6e/42116efc40c443b1c81d65de095e7b4e.webp';
//     }
//     try {
//       final imageUrl =
//     await storageRef.child("users/me/profile.png").getDownloadURL();
//       // var urlRef =
//       //     _firebaseStorage.child('wearable').child('${img.toLowerCase()}.png');
//       // var imgUrl = await urlRef.getDownloadURL();
//       print(imageUrl);
//       return imageUrl;
//     } catch (e) {
//       print('not found');
//       return 'https://i.pinimg.com/originals/42/11/6e/42116efc40c443b1c81d65de095e7b4e.webp';
//     }
//   }

//   void init() {
//     // getImg();
//     // super.init();
//   }
// }
