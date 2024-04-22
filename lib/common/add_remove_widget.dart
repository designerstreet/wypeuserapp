import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class AddRemoveWidget extends StatefulWidget {
  String title;
  String subtitle;
  bool isOnlyRemove;
  String? price;
  bool isSelected;
  AddRemoveWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.isOnlyRemove,
      required this.isSelected,
      this.price});

  @override
  State<AddRemoveWidget> createState() => _AddRemoveWidgetState();
}

class _AddRemoveWidgetState extends State<AddRemoveWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.readexPro(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkGradient),
              ),
              5.height,
              Text(
                widget.subtitle,
                style: GoogleFonts.readexPro(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          widget.price != null
              ? Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    widget.price ?? "",
                    style: GoogleFonts.readexPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
              : Container(),
          Icon(
            widget.isOnlyRemove
                ? widget.isSelected
                    ? FontAwesomeIcons.add
                    : FontAwesomeIcons.minus
                : widget.isSelected
                    ? FontAwesomeIcons.minus
                    : FontAwesomeIcons.add,
            color: darkGradient,
          )
        ],
      ),
    );
  }
}
