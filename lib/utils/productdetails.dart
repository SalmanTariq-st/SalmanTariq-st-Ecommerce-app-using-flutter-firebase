// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:techor/services/firebaseStorage.dart';
import 'package:techor/utils/builder.dart';

class details extends StatelessWidget {
  final String documentId;
  final String collection;

  details({super.key, required this.documentId, required this.collection});
  final storage = Storage();

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection(collection);

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              futubuilder(
                imagePath: data['imgPath'],
              ),
              SizedBox(height: 30),
              Text(
                '${data['name']}',
                //  . edition ${data['price']}",
                style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 10),
              Text('${data['edition']} . ${data['color']}',
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Color(0xFF868686),
                          fontSize: 18,
                          fontWeight: FontWeight.w600))),
              SizedBox(height: 10),
              Text('\$ ${data['price']}',
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          color: Color(0xFF5956E9),
                          fontSize: 20,
                          fontWeight: FontWeight.w700))),
            ],
          );
        }

        return Text("loading");
      },
    );
  }
}
