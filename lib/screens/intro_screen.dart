// ignore_for_file: use_key_in_widget_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class introScreen extends StatefulWidget {
  @override
  State<introScreen> createState() => _introScreenState();
}

class _introScreenState extends State<introScreen> {
  // late SharedPreferences prefs;

  // void setPrefs() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  @override
  void initState() {
    // TODO: implement initState
    // setPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5956E9),
      // ignore: prefer_const_literals_to_create_immutables
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Text('Find Your\nGadget',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                          fontSize: 68,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    )),
                Image.asset(
                  'assets/images/introImg.png',
                  // scale: 0.8,
                ),
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                    onTap: (() {
                      // print('Counter  : ${prefs.get('counter')}');
                      // prefs.setInt('counter', 1);
                      // print('Counter  : ${prefs.get('counter')}');

                      Navigator.pushReplacementNamed(context, '/homePage');
                    }),
                    child: Container(
                      width: 314,
                      height: 70,
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Get started',
                          style: GoogleFonts.raleway(
                              textStyle: const TextStyle(
                                  color: Color(0xFF5956E9),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    )),
                const Spacer(),
              ]),
        ),
      ),
    );
  }
}
