// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:techor/screens/home_screen.dart';
import 'package:techor/screens/prodcut_screen.dart';
import 'package:techor/services/localStorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:techor/utils/itemCounter.dart';
import 'package:techor/utils/priceNotifier.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class basket extends StatefulWidget {
  @override
  State<basket> createState() => _basketState();
}

class _basketState extends State<basket> {
  productsData db = productsData();
  final _box = Hive.box('products');
  int sum = 0;

  List products = [];
  bool isEmpty = false;
  Future getPrefs() async {
    if (products.isNotEmpty) {
      products = [];
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final p = prefs.getString('product');
    if (p == '' || p == null) {
      isEmpty = true;
    } else {
      isEmpty = false;
      List data = (json.decode(p.toString()));
      for (var item in data) {
        print('item :  ${item}    knqskn  ');
        sum = sum + int.parse(item['price']);
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
  void initState() {
    // getPrefs();
    if (_box.get('products') != null) {
      db.loadData();
      print(db.products.length);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: SafeArea(
        //   child: FutureBuilder(
        // future: getPrefs(),
        // builder: (context, snapshot) {
        //   if (snapshot.connectionState == ConnectionState.done &&
        //       snapshot.hasData) {
        //     print(snapshot.data.toString().length);

        //     print(' mng : ${snapshot.data}');
        //     Map<String, dynamic> data = snapshot.data! as Map<String, dynamic>;
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: getPrefs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ChangeNotifierProvider(
                      create: (context) => priceCounter(sum),
                      child: Column(
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
                                  'Basket',
                                  style: GoogleFonts.raleway(
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      prefs.setString('product', '');
                                    });
                                  },
                                  child: Icon(
                                    Icons.delete_outline_outlined,
                                    size: 28,
                                    color: Color(0xffFA4A0C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(
                                    child: Text(
                                      'Try adding something to cart',
                                      style: GoogleFonts.raleway(
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ),
                                )
                              : Consumer<priceCounter>(
                                  builder: (context, value, child) {
                                    return Column(
                                      children: [
                                        SingleChildScrollView(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.4,
                                            child: ListView.builder(
                                              itemCount: products.length,
                                              itemBuilder: (context, index) {
                                                if (index >= 0) {
                                                  sum = 0;
                                                }
                                                // value.sum = value.sum +
                                                //     int.parse(products[index]
                                                //         ['price']);
                                                // print(value.sum);

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 20, 20, 15),
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      height: 130,
                                                      // width: 10
                                                      // ,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        children: [
                                                          Image.network(
                                                              products[index]
                                                                  ['imageUrl']),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${products[index]['name']} ${products[index]['edition']}',
                                                                  style: GoogleFonts.raleway(
                                                                      textStyle: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w600)),
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
                                                                              FontWeight.w600)),
                                                                ),
                                                                ChangeNotifierProvider(
                                                                  create: (context) =>
                                                                      itemCount(),
                                                                  child: Consumer<
                                                                      itemCount>(
                                                                    builder: (context,
                                                                        provider,
                                                                        child) {
                                                                      return Row(
                                                                        children: [
                                                                          Text(
                                                                            'Quantity',
                                                                            style:
                                                                                GoogleFonts.raleway(textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (provider.counter != 0) {
                                                                                // sum = sum - int.parse(products[index]['price']);
                                                                                value.decreasePrice(int.parse(products[index]['price']));
                                                                                // print(sum);
                                                                                provider.decreaseCount();
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 20,
                                                                              height: 20,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(color: Color(0xff7DCCEC), borderRadius: BorderRadius.circular(5)),
                                                                              child: Text(
                                                                                '-',
                                                                                style: GoogleFonts.raleway(textStyle: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                7,
                                                                          ),
                                                                          Text(
                                                                            provider.counter.toString(),
                                                                            style:
                                                                                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                7,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (provider.counter < int.parse(products[index]['quantity'])) {
                                                                                // sum = sum + int.parse(products[index]['price']);
                                                                                value.increasePrice(int.parse(products[index]['price']));
                                                                                print(sum);
                                                                                provider.increaseCount();
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              width: 20,
                                                                              height: 20,
                                                                              alignment: Alignment.center,
                                                                              decoration: BoxDecoration(color: Color(0xff7DCCEC), borderRadius: BorderRadius.circular(5)),
                                                                              child: Text(
                                                                                '+',
                                                                                style: GoogleFonts.raleway(textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 65),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total',
                                                  style: GoogleFonts.raleway(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(0,
                                                                      0, 0, 1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))),
                                              Text('\$ ${value.sum}',
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
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Color(0xffE5E5E5),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                top: Radius.circular(18),
                                              )),
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  height: 550,
                                                  // width: 400,
                                                  decoration: BoxDecoration(
                                                      // borderRadius: Border
                                                      ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Text('Details',
                                                          style: GoogleFonts.raleway(
                                                              textStyle: const TextStyle(
                                                                  fontSize: 30,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700))),
                                                      SizedBox(
                                                        height: 25,
                                                      ),
                                                      SizedBox(
                                                        width: 350,
                                                        child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          hintText:
                                                              'XXXX XXXX XXXX XXXX',
                                                          labelText: 'Number',
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        // ignore: prefer_const_literals_to_create_immutables
                                                        children: [
                                                          SizedBox(
                                                            width: 150,
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      labelText:
                                                                          'Expier Date',
                                                                      hintText:
                                                                          'XX/XX'),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 150,
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: const BorderSide(
                                                                            width:
                                                                                2,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                      labelText:
                                                                          'CVV',
                                                                      hintText:
                                                                          'XXX'),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 350,
                                                        child: TextField(
                                                            decoration:
                                                                InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          labelText: 'Name',
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 65),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Total',
                                                                style: GoogleFonts.raleway(
                                                                    textStyle: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w400))),
                                                            Text(
                                                                '\$ ${value.sum}',
                                                                style: GoogleFonts.raleway(
                                                                    textStyle: const TextStyle(
                                                                        color: Color(
                                                                            0xff5956E9),
                                                                        fontSize:
                                                                            22,
                                                                        fontWeight:
                                                                            FontWeight.w700))),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 350,
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xff5956E9),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text('Pay',
                                                            style: GoogleFonts.raleway(
                                                                textStyle: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700))),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 314,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                color: Color(0xff5956E9),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text('Checkout',
                                                style: GoogleFonts.raleway(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700))),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                        ],
                      ),
                    );
                  }
                  return Text('Try Again');
                }),
          ),
        ),
        // }
        //       return CircularProgressIndicator(
        //         color: Colors.red,
        //       );
        //     },
        // )
      ),
    );
  }
}
