import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:techor/services/firebaseStorage.dart';
import 'package:techor/services/localStorage.dart';
import 'package:techor/utils/builder.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:colour/colour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techor/utils/favouriteNotifier.dart';

class product extends StatefulWidget {
  @override
  State<product> createState() => _productState();
}

String selectedColor = '';
const Map<String, Color> colorStringToColor = {
  'amber': Colors.amber,
  'amberAccent': Colors.amberAccent,
  'black': Colors.black,
  'black12': Colors.black12,
  'black26': Colors.black26,
  'black38': Colors.black38,
  'black45': Colors.black45,
  'black54': Colors.black54,
  'black87': Colors.black87,
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
  'blueGrey': Colors.blueGrey,
  'brown': Colors.brown,
  'cyan': Colors.cyan,
  'cyanAccent': Colors.cyanAccent,
  'deepOrange': Colors.deepOrange,
  'deepOrangeAccent': Colors.deepOrangeAccent,
  'deepPurple': Colors.deepPurple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'green': Colors.green,
  'greenAccent': Colors.greenAccent,
  'grey': Colors.grey,
  'indigo': Colors.indigo,
  'indigoAccent': Colors.indigoAccent,
  'lightBlue': Colors.lightBlue,
  'lightBlueAccent': Colors.lightBlueAccent,
  'lightGreen': Colors.lightGreen,
  'lightGreenAccent': Colors.lightGreenAccent,
  'lime': Colors.lime,
  'limeAccent': Colors.limeAccent,
  'orange': Colors.orange,
  'orangeAccent': Colors.orangeAccent,
  'pink': Colors.pink,
  'pinkAccent': Colors.pinkAccent,
  'purple': Colors.purple,
  'purpleAccent': Colors.purpleAccent,
  'red': Colors.red,
  'redAccent': Colors.redAccent,
  'teal': Colors.teal,
  'tealAccent': Colors.tealAccent,
  'transparent': Colors.transparent,
  'white': Colors.white,
  'white10': Colors.white10,
  'white12': Colors.white12,
  'white24': Colors.white24,
  'white30': Colors.white30,
  'white38': Colors.white38,
  'white54': Colors.white54,
  'white60': Colors.white60,
  'white70': Colors.white70,
  'yellow': Colors.yellow,
  'yellowAccent': Colors.yellowAccent,
  'silver': Color(0xffD6D6D6),
};

class _productState extends State<product> {
  int activeInde = 0;
  Storage storage = Storage();
  final _box = Hive.box('products');
  productsData db = productsData();
  late SharedPreferences prefs;
  bool isFavourite = false;
  // late final url;
  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Icon favIcon(final path) {
    final p = prefs.getString('favourites');
    if (p == '' || p == null) {
      print('abcmnz');
      isFavourite = false;
      return Icon(
        Icons.favorite_outline,
        size: 28,
      );
    } else {
      // isFavourite = true;
      // return Icon(
      //   Icons.favorite,
      //   size: 28,
      // );
      print('objectttttttttttt');
      List data = (json.decode(p.toString()));
      for (var item in data) {
        print('item  ${item['imageUrl']}');
        // final a = item as Map;
        // print(a);

        // print(item['imgPath']);

        if (item['imageUrl'].toString() == path.toString()) {
          print('MAinnnn');
          isFavourite = true;
          return Icon(
            Icons.favorite,
            color: Color(0xFF5956E9),
            size: 28,
          );
        }
      }
      // print('item :  ${item}    knqskn  ');
      // sum = sum + int.parse(item['price']);
      // products.add(item);
    }
    return Icon(
      Icons.favorite_border_outlined,
      size: 28,
    );
    // data.map((item) => a.add(data[item]));
  }

  @override
  void initState() {
    getPrefs();
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    Map ids = ModalRoute.of(context)!.settings.arguments as Map;
    CollectionReference users =
        FirebaseFirestore.instance.collection(ids['collectionID']);

    // print(ids['docID']);
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<DocumentSnapshot>(
                future: users.doc(ids['docID']).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Color(0xff5956E9),
                    ));
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    print(data.runtimeType);
                    // print(locations[0]['country']);

                    return Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                              // Icon(
                              //   Icons.favorite_border_outlined,
                              //   size: 28,
                              // ),
                              FutureBuilder(
                                  future: storage.downloadURL(data['imgPath']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      return ChangeNotifierProvider(
                                        create: (context) => favourite(
                                            favIcon(snapshot.data),
                                            isFavourite),
                                        child: Consumer<favourite>(
                                            builder: (context, value, child) {
                                          return GestureDetector(
                                              onTap: () async {
                                                print(ids['collectionID']);
                                                print(ids['docID']);
                                                final imgUrl =
                                                    await storage.downloadURL(
                                                        data['imgPath']);
                                                final product = {
                                                  'name': data['name'],
                                                  'edition': data['edition'],
                                                  'price': data['price'],
                                                  'quantity': data['quantity'],
                                                  'imageUrl': imgUrl,
                                                  'color': data['color'],
                                                  'collectionID':
                                                      ids['collectionID'],
                                                  'docID': ids['docID']
                                                };
                                                value.manageFav(prefs, product);
                                                value.checkFavs(prefs, imgUrl);
                                              },
                                              child: value.fav);
                                        }),
                                      );
                                    }
                                    ;
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Icon(
                                        Icons.favorite_outline,
                                        size: 28,
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  })
                            ],
                          ),
                        ),
                        Container(
                          height: 220,
                          child: PageView(
                            controller: controller,
                            children: [
                              for (var element in data['images'])
                                futubuilder(imagePath: element)
                              // futubuilder(imagePath: data['images'][0]),
                              // futubuilder(imagePath: data['images'][1]),
                              // futubuilder(imagePath: data['images'][2]),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SmoothPageIndicator(
                            controller: controller,
                            count: data['images'].length,
                            effect: CustomizableEffect(
                              activeDotDecoration: DotDecoration(
                                width: 10,
                                height: 10,
                                color: Color(0xff5956E9),
                                borderRadius: BorderRadius.circular(24),
                                dotBorder: DotBorder(
                                  padding: 3,
                                  width: 2,
                                  color: Colors.indigo,
                                ),
                              ),
                              dotDecoration: DotDecoration(
                                width: 12,
                                height: 12,
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(16),
                                verticalOffset: 0,
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.65,
                          width: MediaQuery.of(context).size.width,
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height / 1.3,
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '${data['name']} ${data['edition']}',
                                        style: GoogleFonts.raleway(
                                            textStyle: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Container(
                                        child: Column(children: [
                                          Text(
                                            'Colors',
                                            style: GoogleFonts.raleway(
                                                textStyle: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              for (var color in data['colours'])
                                                colorButton(color),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(30),
                                            child: Text(data['description'],
                                                style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        letterSpacing: 0.2,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 65),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Total',
                                                    style: GoogleFonts.raleway(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))),
                                                Text('\$ ${data['price']}',
                                                    style: GoogleFonts.raleway(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Color(
                                                                    0xff5956E9),
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700))),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final imgUrl = await storage
                                                  .downloadURL(data['imgPath']);
                                              final product = {
                                                'name': data['name'],
                                                'edition': data['edition'],
                                                'price': data['price'],
                                                'quantity': data['quantity'],
                                                'imageUrl': imgUrl
                                              };
                                              // ids['object']
                                              //     .products
                                              //     .add(product);
                                              // ids['object'].updateDatabase();
                                              // db.products.add(product);
                                              // db.updateDatabase();
                                              print('objecttcv');
                                              // print(ids['object'].products);
                                              // SharedPreferences prefs =
                                              //     await SharedPreferences
                                              //         .getInstance();
                                              final temp =
                                                  prefs.getString('product');
                                              if (temp == null ||
                                                  temp.isEmpty) {
                                                db.products.add(product);
                                              } else {
                                                List temp1 = json.decode(temp);
                                                // db.products.add(temp1);
                                                temp1.forEach((element) {
                                                  db.products.add(element);
                                                });
                                                db.products.add(product);
                                              }
                                              prefs.setString('product',
                                                  json.encode(db.products));
                                              // print(db.products);
                                              // product.addAll(temp);
                                              // prefs.setString('product',
                                              //     json.encode(product));
                                              print('object');
                                              Navigator.pushReplacementNamed(
                                                  context, '/basket');
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 314,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff5956E9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text('Add to basket',
                                                  style: GoogleFonts.raleway(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700))),
                                            ),
                                          )
                                        ]),
                                      )
                                    ],
                                  ))),
                        ),
                      ],
                    );
                  }

                  return Text('Try Agian');
                }),
          ],
        ),
      ),
    );
  }

  Widget colorButton(String colour) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = colour;
          print(selectedColor);
        });
      },
      child: Container(
        // padding: EdgeInsets.all(8),
        height: 50,
        width: 110,

        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1,
              color: selectedColor == colour
                  ? Color(0xff868686)
                  : Color(0xffE3E3E3)),
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000).withOpacity(0.06),

              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: colorStringToColor[colour.toLowerCase()],
                  borderRadius: BorderRadius.circular(30)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(colour,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
