import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants.dart';

class ProfileContainer extends StatefulWidget {
  Function()? onTap;
  IconData? icon;
  String text;
  String? subText;
  ProfileContainer(
      {super.key, required this.onTap, required this.icon, required this.text, this.subText});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: height(context) * 0.06,
        decoration: BoxDecoration(
          color: widget.text == "Log Out" ? Colors.redAccent : Colors.white,
          border: Border.all(
              color: widget.text == "Log Out" ? Colors.white : darkGradient),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            10.width,
            Icon(
              widget.icon,
              color: widget.text == "Log Out" ? Colors.white : lightGradient,
              size: 18,
            ),
            15.width,
            Text(
              widget.text,
              style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      widget.text == "Log Out" ? Colors.white : darkGradient),
            ),
            Spacer(),
            widget.subText == null ? Container() : Text(
              widget.subText ?? "",
              style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                  darkGradient.withOpacity(0.8)),
            ),
            widget.text == "Log Out"
                ? Container()
                : Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  )
          ],
        ),
      ),
    );
  }
}
