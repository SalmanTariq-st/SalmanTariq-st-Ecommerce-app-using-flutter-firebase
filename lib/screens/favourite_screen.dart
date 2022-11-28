import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class favouriteScreen extends StatelessWidget {
  List products = [];
  bool isEmpty = false;
  Future getPrefs() async {
    if (products.isNotEmpty) {
      products = [];
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final p = prefs.getString('favourites');
    if (p == '' || p == null) {
      isEmpty = true;
    } else {
      isEmpty = false;
      List data = (json.decode(p.toString()));
      for (var item in data) {
        print('item :  ${item}    knqskn  ');

        products.add(item);
      } // data.map((item) => a.add(data[item]));
    }
    // a = map;

    // setState(() {
    //   // print('acd efg : ${a[0]}');
    //   // return a;
    //   print('a :   ${a}');
    // });
    print(products.length);
    return products;

    // print(json.decode(p.toString()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 28,
                                ),
                              ),
                              Text(
                                'Favorites',
                                style: GoogleFonts.raleway(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Text('')
                            ])),
                    isEmpty
                        ? Column(
                            children: [
                              Image.asset(
                                'assets/images/noFavs.png',
                                scale: 1.2,
                              ),
                              Text('No favorites yet',
                                  style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600)))
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.3,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 20, 40, 15),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context, '/productView',
                                                arguments: {
                                                  'collectionID':
                                                      products[index]
                                                          ['collectionID'],
                                                  'docID': products[index]
                                                      ['docID'],
                                                });
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(20),
                                              height: 130,
                                              // width: 10,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Row(children: [
                                                Image.network(products[index]
                                                    ['imageUrl']),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${products[index]['name']}',
                                                            style: GoogleFonts.raleway(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                          ),
                                                          Text(
                                                            '${products[index]['edition']}',
                                                            style: GoogleFonts.raleway(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ),
                                                          Text(
                                                            ' \$ ${products[index]['price']}',
                                                            style: GoogleFonts.raleway(
                                                                textStyle: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Color(
                                                                        0xff5956E9),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                          ),
                                                        ]))
                                              ])),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          )
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      )),
    );
  }
}
