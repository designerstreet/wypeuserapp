import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/provider/language.dart';

import '../constants.dart';
import '../services/firebase_services.dart';

class CarContainer extends StatefulWidget {
  String name;
  String model;
  String registration;
  bool isSelected;
  bool isFromHome;
  Function()? deleteCar;
  CarContainer(
      {super.key,
      required this.name,
      required this.model,
      required this.registration,
      required this.isSelected,
      required this.isFromHome,
      this.deleteCar});

  @override
  State<CarContainer> createState() => _CarContainerState();
}

class _CarContainerState extends State<CarContainer> {
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Container(
      padding: EdgeInsets.all(15),
      height: height(context) * 0.15,
      width: width(context),
      decoration: BoxDecoration(
          border: Border.all(color: darkGradient),
          borderRadius: BorderRadius.circular(20),
          color: !widget.isSelected ? Colors.white : darkGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.name,
                style: GoogleFonts.readexPro(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: widget.isSelected ? Colors.white : darkGradient),
              ),
              Spacer(),
              widget.isFromHome
                  ? InkWell(
                      onTap: widget.deleteCar,
                      child: Icon(
                        FontAwesomeIcons.trash,
                        size: 17,
                        color: Colors.redAccent,
                      ),
                    )
                  : widget.isSelected
                      ? Icon(
                          FontAwesomeIcons.circleCheck,
                          color: Colors.white,
                        )
                      : Container(),
            ],
          ),
          10.height,
          Row(
            children: [
              Column(
                children: [
                  Text(
                    userLang.isAr ? "نموذج" : "Model",
                    style: GoogleFonts.readexPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    widget.model,
                    style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isSelected ? Colors.white : darkGradient),
                  ),
                ],
              ),
              25.width,
              Column(
                children: [
                  Text(
                    userLang.isAr ? "رقم التسجيل" : "Registration Number",
                    style: GoogleFonts.readexPro(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    widget.registration,
                    style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: widget.isSelected ? Colors.white : darkGradient),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
