import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/subscription_screens/wype_plus_screen.dart';

class PriceContainer extends StatefulWidget {
  String title;
  String subtitle;
  String price;
  double? length;
  String service;
  Function()? onTap;
  Widget? widget;
  PriceContainer(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.price,
      this.length,
      this.onTap,
      this.widget,
      required this.service});

  @override
  State<PriceContainer> createState() => _PriceContainerState();
}

class _PriceContainerState extends State<PriceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  
  }
}
