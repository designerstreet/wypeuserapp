import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants.dart';

class ProfileContainer extends StatefulWidget {
  Function()? onTap;
  var icon;
  String text;
  String? subText;
  ProfileContainer(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.text,
      this.subText});

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            10.width,
            Image.asset(
              widget.icon,
              color: widget.text == "Log Out" ? Colors.white : black,
              width: width(context) * 0.070,
            ),
            15.width,
            Text(widget.text, style: myFont500
                //  GoogleFonts.readexPro(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500,
                //     color:
                //         widget.text == "Log Out" ? Colors.white : darkGradient),
                ),
            const Spacer(),
            widget.subText == null
                ? Container()
                : Text(
                    widget.subText ?? "",
                    style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: darkGradient.withOpacity(0.8)),
                  ),
            // widget.text == "Log Out"
            //     ? Container()
            //     : const Icon(
            //         Icons.chevron_right,
            //         color: Colors.grey,
            //       )
          ],
        ),
      ),
    );
  }
}
