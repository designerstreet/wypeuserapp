import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/services/location_services.dart';

class SelectSlot extends StatefulWidget {
  const SelectSlot({super.key});

  @override
  State<SelectSlot> createState() => _SelectSlotState();
}

class _SelectSlotState extends State<SelectSlot> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FadeIn(
            child: Scaffold(
      body: Column(
        children: [
          currentAddress == null
              ? Container()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    children: [
                      const FaIcon(
                        Icons.pin_drop_outlined,
                        size: 30,
                        color: skyBlue,
                      ),
                      Text(
                          "${currentAddress!.name},\n ${currentAddress!.administrativeArea}${currentAddress!.country}, ${currentAddress!.postalCode}",
                          textAlign: TextAlign.left,
                          style:
                              myFont500.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(
                        'change'.toUpperCase(),
                        style: myFont28_600.copyWith(color: Utils().skyBlue),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Utils().skyBlue,
                        size: 18,
                      )
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PrimaryButton(text: 'CONFIRM LOCATION', onTap: () {}),
          ),
          20.height
        ],
      ),
    )));
  }
}
