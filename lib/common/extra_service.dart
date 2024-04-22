import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/provider/language.dart';

class ExtraServiceContainer extends StatefulWidget {
  String noOfWash;
  bool isSelected;
  String price;
  ExtraServiceContainer(
      {super.key,
      required this.noOfWash,
      required this.isSelected,
      required this.price});

  @override
  State<ExtraServiceContainer> createState() => _ExtraServiceContainerState();
}

class _ExtraServiceContainerState extends State<ExtraServiceContainer> {
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.isSelected ? darkGradient : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: darkGradient),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.noOfWash}",
                  style: GoogleFonts.readexPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: widget.isSelected ? Colors.white : darkGradient),
                ),
                5.height,
                Text(
                  userLang.isAr
                      ? "يشمل فقط ${widget.noOfWash}"
                      : "Includes only ${widget.noOfWash}",
                  style: GoogleFonts.readexPro(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          10.width,
          Text(
            "${widget.price} QAR",
            style: GoogleFonts.readexPro(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.isSelected ? Colors.white : darkGradient),
          ),
        ],
      ),
    );
  }
}
