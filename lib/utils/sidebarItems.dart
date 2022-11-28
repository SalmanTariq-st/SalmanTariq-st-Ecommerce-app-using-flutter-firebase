import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class sidebarItems extends StatelessWidget {
  final item;
  final icon;

  sidebarItems({super.key, required this.item, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 80,
        child: Column(children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                item,
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(
            height: 50,
            color: Color(0xFFF4F4F8),
            thickness: 1,
            indent: 35,
            endIndent: 10,
          )
        ]));
  }
}
