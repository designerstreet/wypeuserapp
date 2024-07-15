import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class AddressList extends StatefulWidget {
  const AddressList({super.key});

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: FadeIn(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: height(context) * 0.06,
            ),
            Row(
              children: [
                InkWell(                    borderRadius: BorderRadius.circular(20),

                  onTap: () => popNav(context),
                  child: Icon(
                    Icons.chevron_left,
                    size: 29,
                    color: lightGradient,
                  ),
                ),
                10.width,
                Text(
                  "Addresses",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightGradient),
                ),
              ],
            ),
            30.height,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Home",
                        style: GoogleFonts.readexPro(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: darkGradient),
                      ),
                      10.height,
                      Text(
                        "John Doe Apartment",
                        style: GoogleFonts.readexPro(
                            fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  )),
                  10.width,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(FontAwesomeIcons.pencil, color: darkGradient, size: 17,),
                    20.height,
                    Icon(FontAwesomeIcons.trash, color: Colors.redAccent, size: 17,),

                  ],)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
