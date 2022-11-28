// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:techor/services/firebaseStorage.dart';

class futubuilder extends StatelessWidget {
  final imagePath;
  final storage = Storage();

  futubuilder({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.downloadURL(imagePath),
      builder: ((context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            width: 180,
            height: 180,
            color: Colors.transparent,
            child: Image.network(snapshot.data!),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xff5956E9),
          ));
        }
        return Container();
      }),
    );
  }
}
