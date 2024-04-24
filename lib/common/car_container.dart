import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      padding: const EdgeInsets.all(15),
      height: height(context) * 0.17,
      width: width(context),
      decoration: BoxDecoration(
        // color: darkGradient,
        border: Border.all(
            color: !widget.isSelected ? gray : Utils().lightBlue,
            width: widget.isSelected ? 2 : 0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isSelected
              ? Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'current'.toUpperCase(),
                    style: myFont28_600.copyWith(color: Utils().lightBlue),
                  ),
                )
              : Container(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/caricon.png',
                  height: height(context) * 0.080,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.readexPro(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.model,
                        style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.isFromHome
                    ? InkWell(
                        onTap: widget.deleteCar,
                        child: const Icon(
                          FontAwesomeIcons.trash,
                          size: 17,
                          color: Colors.grey,
                        ),
                      )
                    : Text(
                        userLang.isAr ? "نموذج" : "Model",
                        style: GoogleFonts.readexPro(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
              ],
            ),
          ),
          10.height,
        ],
      ),
    );
  }
}
