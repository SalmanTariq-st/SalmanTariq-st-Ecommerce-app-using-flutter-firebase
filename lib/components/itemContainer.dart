import 'package:flutter/material.dart';
import 'package:techor/services/localStorage.dart';

import '../utils/productdetails.dart';

class itemContainer extends StatelessWidget {
  final docID;
  final collectionID;
  final data;

  const itemContainer(
      {super.key,
      required this.docID,
      required this.collectionID,
      required this.data});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productView', arguments: {
          'collectionID': collectionID,
          'docID': docID,
        });
      },
      child: Container(
        height: 370,
        width: 270,
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 70,
                left: 19.5,
                child: Container(
                  width: 240,
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ), //Container
              Positioned(
                top: 2,
                left: 48,
                child: Container(
                    width: 180,
                    height: 350,
                    color: Colors.transparent,
                    // color: Colors.black,
                    child: details(
                      documentId: docID,
                      collection: collectionID,
                    )),
              ), //
            ],
          ),
        ),
      ),
    );
  }
}
