import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/onBoarding/extra_services.dart';

class PriceContainer extends StatefulWidget {
  String title;
  String subtitle;
  String price;
  PriceContainer(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.price});

  @override
  State<PriceContainer> createState() => _PriceContainerState();
}

class _PriceContainerState extends State<PriceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkGradient),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.readexPro(
                fontSize: 16, fontWeight: FontWeight.w600, color: darkGradient),
          ),
          10.height,
          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.readexPro(
                fontSize: 13, fontWeight: FontWeight.w600, color: grey),
          ),
          5.height,
          const Divider(),
          5.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Starts from  ",
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkGradient),
              ),
              Text(
                "QAR ${widget.price}",
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
