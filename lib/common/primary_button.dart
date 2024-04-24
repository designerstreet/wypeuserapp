import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class PrimaryButton extends StatelessWidget {
  String text;
  Function()? onTap;
  PrimaryButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) * 0.067,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Utils().lightBlue,
              foregroundColor: Utils().whiteColor),
          onPressed: onTap,
          child: Text(
            text.toUpperCase(),
            style: myFont28_600.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Utils().whiteColor),
          )),
    );
  }
}
