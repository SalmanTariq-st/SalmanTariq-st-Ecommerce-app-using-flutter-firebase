// import 'main.dart';

// ignore_for_file: unused_import, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unused_field, prefer_final_fields

import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:flutter/material.dart';
import 'package:techor/components/itemContainer.dart';
import 'package:techor/screens/basket_screen.dart';
import 'package:techor/screens/prodcut_screen.dart';
import 'package:techor/services/firebaseStorage.dart';
import 'package:techor/services/localStorage.dart';
import 'package:techor/utils/builder.dart';
import 'package:techor/utils/productdetails.dart';
import 'package:techor/utils/sidebarItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../home_icons.dart';
import 'package:firebase_storage/firebase_storage.dart';

class KFDrawerRun extends StatelessWidget {
  const KFDrawerRun({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainWidget();
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late KFDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(initialPage: HomePage(), items: [
      KFDrawerItem.initWithPage(
        // icon: Icon(Icons.person, color: Colors.white),
        text: sidebarItems(item: ' Profile', icon: Icons.person_outline),

        page: Page2(),
      ),
      KFDrawerItem.initWithPage(
        text: sidebarItems(
            item: ' My Orders', icon: Icons.shopping_cart_outlined),
        onPressed: () => Navigator.pushNamed(context, '/intro'),
      ),
      KFDrawerItem.initWithPage(
        text: sidebarItems(
            item: ' Favorites', icon: Icons.favorite_outline_sharp),
        onPressed: () => Navigator.pushNamed(context, '/favourite'),
      ),
      KFDrawerItem.initWithPage(
        text:
            sidebarItems(item: ' Delivery', icon: Icons.shopping_bag_outlined),
        // page: Page2(),
        onPressed: () {
          Navigator.pushNamed(context, '/basket');
        },
      ),
      KFDrawerItem.initWithPage(
        text: sidebarItems(item: ' Settings', icon: Icons.settings_outlined),
        page: Page2(),
      )
    ]);
  }

  int _selectedIndex = 0;
  List screens = [KFDrawerRun(), KFDrawerRun(), KFDrawerRun(), KFDrawerRun()];

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/productView': (context) => product(),
        '/basket': (context) => basket(),
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomInset: false,
        body: KFDrawer(
          // shadowOffset: 10,
          // drawerWidth: 0.80,

          minScale: 0.80,
          borderRadius: 30.0,
          shadowBorderRadius: 20.0,
          menuPadding: EdgeInsets.fromLTRB(0, 10, 0, 5),
          scrollable: true,

          controller: _drawerController,
          // header: Align(
          //   // alignment: Alignment.centerLeft,
          //   // child: Container(
          //   //   child: Text('home'),
          //   // ),
          // ),

          // header:
          header: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Container(child: Text('')),
            ),
          ),

          decoration: BoxDecoration(
            color: Color(0xFF5956E9),
          ),
        ),
      ),
    );
  }
}

class HomePage extends KFDrawerContent {
  @override
  HomeState createState() => HomeState();
}

productsData data = productsData();

class HomeState extends State<HomePage> {
  Storage storage = Storage();
  int indicator = 0;
  String _collection = 'productDetails';
  bool _isSearching = false;
  List docIds = [];
  TextEditingController searchText = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  Future getDocs() async {
    await FirebaseFirestore.instance
        .collection(_collection)
        .get()
        .then((value) => value.docs.forEach((element) {
              print(element.id);
              docIds.add(element.id);
            }));
    print('object ');
    return docIds;

    // print('object');
  }

  List SearchList = [];
  List collectionsName = ['laptops', 'phones', 'productDetails', 'tablets'];

  Future search(String query) async {
    List itemsList = [];

    if (query.isNotEmpty) {
      final documentList = await (FirebaseFirestore.instance
          .collection(collectionsName[0])
          .where("searchArray", arrayContains: query.toLowerCase())
          .get());
      final documentList1 = await (FirebaseFirestore.instance
          .collection(collectionsName[1])
          .where("searchArray", arrayContains: query.toLowerCase())
          .get());
      final documentList2 = await (FirebaseFirestore.instance
          .collection(collectionsName[2])
          .where("searchArray", arrayContains: query.toLowerCase())
          .get());
      final documentList3 = await (FirebaseFirestore.instance
          .collection(collectionsName[3])
          .where("searchArray", arrayContains: query.toLowerCase())
          .get());
      if (documentList.docs.isNotEmpty) {
        print('truee 1');
        SearchList.clear();

        final temp = documentList.docs.map((e) => e.data()).toList();
        itemsList = itemsList + documentList.docs.map((e) => e.data()).toList();
      }
      if (documentList1.docs.isNotEmpty) {
        SearchList.clear();

        print('truee 2');

        itemsList =
            itemsList + documentList1.docs.map((e) => e.data()).toList();
      }
      if (documentList2.docs.isNotEmpty) {
        SearchList.clear();

        print('truee 3');

        itemsList =
            itemsList + documentList2.docs.map((e) => e.data()).toList();
      }
      if (documentList3.docs.isNotEmpty) {
        SearchList.clear();

        print('truee 4');

        itemsList =
            itemsList + documentList3.docs.map((e) => e.data()).toList();
      } else {
        print('tru');

        // SearchList.clear();
      }

      setState(() {
        SearchList = itemsList.toList();
      });
      print('length :  ${SearchList.length}');
    } else {
      SearchList.clear();
      setState(() {});
    }
  }

  @override
  initState() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFFE5E5E5),
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        child: Material(
                          shadowColor: Colors.transparent,
                          color: Colors.transparent,
                          child: GestureDetector(
                            child: Container(
                              width: 25,
                              child: _isSearching
                                  ? Icon(Icons.arrow_back)
                                  : Image.asset(
                                      'assets/images/m.png',
                                    ),
                            ),
                            onTap: _isSearching
                                ? (() {
                                    setState(() {
                                      SearchList.clear();
                                      searchText.clear();
                                      _isSearching = false;
                                    });
                                  })
                                : widget.onMenuPressed,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            border: _isSearching
                                ? Border.all(width: 2, color: Color(0xFF5956E9))
                                : Border.all(
                                    width: 2, color: Color(0xFFC9C9C9)),
                            borderRadius: BorderRadius.circular(26)),
                        width: 270,
                        child: TextField(
                            controller: searchText,
                            onChanged: (query) => setState(() {
                                  print(query);
                                  search(query);
                                }),
                            onTap: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: 'Search',
                                icon: Icon(
                                  Icons.search_outlined,
                                  color: Colors.black,
                                  size: 26,
                                ),
                                border: InputBorder.none)),
                      ),
                    ],
                  ),
                ),
              ),
              _isSearching &&
                      SearchList.isNotEmpty &&
                      searchText.text.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text('Found ${SearchList.length} Results',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600))),
                    )
                  : Text(''),
              SizedBox(
                  // height: 20,
                  ),
              _isSearching &&
                      SearchList.isNotEmpty &&
                      searchText.text.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 1.27,
                        child: ListView.builder(
                          itemCount: SearchList.length % 2 == 0
                              ? SearchList.length ~/ 2
                              : SearchList.length ~/ 2 + 1,
                          itemBuilder: (BuildContext, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(5, 4, 5, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Text(SearchList[index * 2]['name']),
                                  Container(
                                      decoration: BoxDecoration(
                                        //  color: Colors.amber,
                                        borderRadius: BorderRadius.circular(20),
                                        // color: Colors.black
                                      ),
                                      height: 320,
                                      width: 200,
                                      child: Center(
                                          child: Stack(
                                        children: [
                                          Positioned(
                                            top: 70,
                                            left: 4,
                                            // right: 1,
                                            child: Container(
                                              width: 186,
                                              height: 222,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 2,
                                            child: Container(
                                                color: Colors.transparent,
                                                width: 180,
                                                height: 350,
                                                child: Column(children: [
                                                  futubuilder(
                                                    imagePath:
                                                        SearchList[index * 2]
                                                            ['imgPath'],
                                                  ),
                                                  SizedBox(height: 30),
                                                  Text(
                                                    '${SearchList[index * 2]['name']}',
                                                    //  . edition ${data['price']}",
                                                    style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'from \$ ${SearchList[index]['price']}',
                                                    //  . edition ${data['price']}",
                                                    style: GoogleFonts.raleway(
                                                        textStyle: TextStyle(
                                                            color: Color(
                                                                0xFF5956E9),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                  )
                                                ])),
                                          ),
                                        ],
                                      ))),
                                  if (index * 2 + 1 + 1 < SearchList.length)
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        height: 320,
                                        width: 200,
                                        child: Center(
                                            child: Stack(
                                          children: [
                                            Positioned(
                                              top: 70,
                                              left: 4,
                                              // right: 2,
                                              child: Container(
                                                width: 186,
                                                height: 222,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 2,
                                              child: Container(
                                                  color: Colors.transparent,
                                                  width: 180,
                                                  height: 310,
                                                  child: Column(children: [
                                                    futubuilder(
                                                      imagePath: SearchList[
                                                              index * 2 + 1]
                                                          ['imgPath'],
                                                    ),
                                                    SizedBox(height: 30),
                                                    Text(
                                                      '${SearchList[index * 2 + 1]['name']}',
                                                      //  . edition ${data['price']}",
                                                      style: GoogleFonts.raleway(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'from \$ ${SearchList[index]['price']}',
                                                      //  . edition ${data['price']}",
                                                      style: GoogleFonts.raleway(
                                                          textStyle: TextStyle(
                                                              color: Color(
                                                                  0xFF5956E9),
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
                                                    )
                                                  ])),
                                            ), //
                                          ],
                                        ))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : _isSearching && searchText.text.isNotEmpty
                      ? Center(
                          // padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Image.asset(
                                  'assets/images/notFound.png',
                                  scale: 0.1,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Item not found',
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Try a more generic search term or try',
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                          height: 2,
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400))),
                              Text(' looking for alternative products.',
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                        )
                      : _isSearching
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text('Type the name',
                                  style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600))),
                            )
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Order online                 ',
                                        style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                                fontSize: 34,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                      Text(
                                        'collect in store            ',
                                        style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                                fontSize: 34,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            docIds.clear();
                                            _collection = 'productDetails';
                                            indicator = 0;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: indicator == 0
                                                      ? BorderSide(
                                                          width: 2,
                                                          color:
                                                              Color(0xFF5956E9))
                                                      : BorderSide.none)),
                                          child: Text('Wearable',
                                              style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                      fontSize: 17,
                                                      color: indicator == 0
                                                          ? Color(0xFF5956E9)
                                                          : Color(0xFF9A9A9D),
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            docIds.clear();
                                            _collection = 'laptops';
                                            indicator = 1;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 6),

                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: indicator == 1
                                                      ? BorderSide(
                                                          width: 2,
                                                          color:
                                                              Color(0xFF5956E9))
                                                      : BorderSide.none)),
                                          // decoration: BoxDecoration(
                                          //     border: Border(
                                          //         bottom:
                                          //             BorderSide(width: 1, color: Colors.black)
                                          //             )),
                                          child: Text('Laptops',
                                              style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                      fontSize: 17,
                                                      color: indicator == 1
                                                          ? Color(0xFF5956E9)
                                                          : Color(0xFF9A9A9D),
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            docIds.clear();
                                            _collection = 'phones';
                                            indicator = 2;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: indicator == 2
                                                      ? BorderSide(
                                                          width: 2,
                                                          color:
                                                              Color(0xFF5956E9))
                                                      : BorderSide.none)),
                                          child: Text('Phones',
                                              style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                      fontSize: 17,
                                                      color: indicator == 2
                                                          ? Color(0xFF5956E9)
                                                          : Color(0xFF9A9A9D),
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            docIds.clear();
                                            _collection = 'tablets';
                                            indicator = 3;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: indicator == 3
                                                      ? BorderSide(
                                                          width: 2,
                                                          color:
                                                              Color(0xFF5956E9))
                                                      : BorderSide.none)),
                                          child: Text('Tablets',
                                              style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                      fontSize: 17,
                                                      color: indicator == 3
                                                          ? Color(0xFF5956E9)
                                                          : Color(0xFF9A9A9D),
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                FutureBuilder(
                                    future: getDocs(),
                                    builder: ((context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        print('abc  ${snapshot.data}');
                                        return
                                            // indicator == 0 ?
                                            SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                30, 0, 30, 0),
                                            child: Row(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                itemContainer(
                                                  docID: docIds[0],
                                                  collectionID: _collection,
                                                  data: data,
                                                ),
                                                itemContainer(
                                                  docID: docIds[1],
                                                  collectionID: _collection,
                                                  data: data,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                      ;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      return Container();
                                    })),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('see more ',
                                            style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xFF5956E9),
                                                    fontWeight:
                                                        FontWeight.w700))),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Color(0xFF5956E9),
                                        )
                                      ]),
                                )
                              ],
                            ),

              // Container(
              //   // color: Colors.green,
              //   height: 450,
              //   width: 270,
              //   child: Center(
              //     child: Stack(
              //       children: [
              //         Positioned(
              //           top: 70,
              //           left: 19,
              //           child: Container(
              //             width: 245,
              //             height: 290,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(24),
              //               color: Colors.white,
              //             ),
              //           ),
              //         ), //Container
              //         Positioned(
              //           top: 2,
              //           left: 48,
              //           child: Container(
              //               width: 180,
              //               height: 300,
              //               color: Colors.transparent,
              //               // color: Colors.black,
              //               child: details(
              //                 documentId: 'appleWatch',
              //               )),
              //         ), //
              //       ],
              //     ),
              //   ),
              // )
              // Container(
              //   height: 300,
              //   width: 250,
              //   child: Column(
              //     children: [
              //       Expanded(
              //           child: Container(
              //         color: Colors.red,
              //       )),
              //       Expanded(
              //           flex: 2,
              //           child: Container(
              //             color: Colors.amber,
              //           ))
              //     ],
              //   ),
              // )

              // Expanded(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Page1'),
              //     ],
              //   ),
              // ),
              // Positioned(
              //   top: MediaQuery.of(context).size.height * 1 / 3,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 18.0),
              //     child: Container(
              //       width: MediaQuery.of(context).size.width,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           Icon(
              //             Home.home,
              //             size: 28,
              //             color: Color(0xFF5956E9),
              //             shadows: [
              //               Shadow(
              //                   color: Color.fromARGB(255, 115, 113, 236),
              //                   blurRadius: 34.0)
              //             ],
              //           ),
              //           Icon(
              //             Icons.favorite_outline_sharp,
              //             size: 28,
              //           ),
              //           Icon(
              //             Icons.person_outline,
              //             size: 28,
              //           ),
              //           Icon(
              //             Icons.shopping_cart_outlined,
              //             size: 28,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page2 extends KFDrawerContent {
  @override
  Page2State createState() => Page2State();
}

class Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  child: Material(
                    shadowColor: Colors.transparent,
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      onPressed: widget.onMenuPressed,
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black)),
                  child: TextField(),
                ),
              ],
            ),
            //  Text('Order online\ncollect in store',style: GoogleFonts.raleway(
            //   textStyle:
            //  ),)
          ],
        ),
      ),
    );
  }
}
