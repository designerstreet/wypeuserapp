import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/onBoarding/extra_services.dart';

class PriceContainer extends StatefulWidget {
  String title;
  String subtitle;
  String price;
  double? length;
  String service;
  PriceContainer(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.price,
      this.length,
      required this.service});

  @override
  State<PriceContainer> createState() => _PriceContainerState();
}

class _PriceContainerState extends State<PriceContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: darkGradient),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  10,
                ),
                topRight: Radius.circular(
                  10,
                ),
              ),
              color: Color.fromRGBO(28, 32, 52, 1),
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    style: myFont28_600.copyWith(color: whiteColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Monthly Plans Available',
                    style: myFont500.copyWith(
                        color: const Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        Icons.add_circle,
                        color: greenColor,
                      )),
                  Text(widget.service.toString()),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text('One wash'),
                        Text(widget.price),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Utils().darkBlue),
                            onPressed: () {},
                            child: Text(
                              'Book Now'.toUpperCase(),
                              style: myFont500.copyWith(color: white),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
          // Text(
          //   widget.title,
          //   style: GoogleFonts.readexPro(
          //       fontSize: 16, fontWeight: FontWeight.w600, color: darkGradient),
          // ),
          // 10.height,
          // Text(
          //   widget.subtitle,
          //   textAlign: TextAlign.center,
          //   style: GoogleFonts.readexPro(
          //       fontSize: 13, fontWeight: FontWeight.w600, color: grey),
          // ),
          // 5.height,
          // const Divider(),
          // 5.height,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Starts from  ",
          //       textAlign: TextAlign.center,
          //       style: GoogleFonts.readexPro(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           color: darkGradient),
          //     ),
          //     Text(
          //       "QAR ${widget.price}",
          //       textAlign: TextAlign.center,
          //       style: GoogleFonts.readexPro(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.green),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
