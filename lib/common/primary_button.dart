// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class PrimaryButton extends StatelessWidget {
  bool isLoading;
  String text;
  Function()? onTap;
  PrimaryButton({
    Key? key,
    this.isLoading = false,
    required this.text,
    this.onTap,
  }) : super(key: key);

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
          child: isLoading
              ? const SizedBox(
                  width: 24, // Adjust as needed
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, // Adjust as needed
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text.toUpperCase(),
                  style: myFont28_600.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Utils().whiteColor),
                )),
    );
  }
}
