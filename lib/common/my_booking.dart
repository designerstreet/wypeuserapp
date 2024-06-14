import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class BookingBuilder extends StatelessWidget {
  String? status;
  var carImg;
  String? carName;
  String? carNumber;
  String? modelNumber;
  String? subscriptionName;
  var time;
  var date;
  String btnName;
  Function()? onTap;
  BookingBuilder({
    Key? key,
    this.status,
    this.carImg,
    this.carName,
    this.carNumber,
    this.modelNumber,
    this.subscriptionName,
    this.time,
    this.date,
    required this.btnName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: greyLight),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                    color: Utils().lightBlue,
                    borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(12),
                        bottomLeft: radiusCircular(12))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "$status".toUpperCase() ?? '',
                    style: myFont500.copyWith(color: Utils().whiteColor),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Image.asset(
                  carImg,
                  width: width(context) * 0.25,
                ),
                20.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      carName ?? '',
                      style: myFont28_600,
                    ),
                    Text(
                      "$carNumber".toUpperCase() ?? '',
                      style: myFont500.copyWith(color: grey),
                    )
                  ],
                )
              ],
            ),
            10.height,
            Text(
              "$modelNumber".toUpperCase() ?? '',
              style: myFont28_600.copyWith(fontSize: 12),
            ),
            5.height,
            Text(
              subscriptionName ?? '',
              style: myFont500.copyWith(color: gray),
            ),
            7.height,
            const Divider(),
            7.height,
            Text(
              'slot selected'.toUpperCase(),
              style: myFont28_600.copyWith(color: gray, fontSize: 11),
            ),
            7.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FaIcon(
                  FontAwesomeIcons.clock,
                  color: gray,
                  size: 20,
                ),
                10.width,
                Text(
                  "$time" ?? '',
                  style: myFont28_600.copyWith(fontSize: 12),
                ),
              ],
            ),
            7.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FaIcon(
                  FontAwesomeIcons.calendar,
                  color: gray,
                  size: 20,
                ),
                10.width,
                Text(
                  "$date" ?? '',
                  style: myFont28_600.copyWith(fontSize: 12),
                ),
              ],
            ),
            10.height,
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           surfaceTintColor: white,
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(30),
            //               side: BorderSide(
            //                 color: Utils().lightBlue,
            //               ))),
            //       onPressed: onTap,
            //       child: Text(
            //         btnName.toUpperCase(),
            //         style: myFont28_600.copyWith(color: Utils().lightBlue),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}

class BookingContainer extends StatelessWidget {
  String title;
  Color color;
  Color borderColor;
  Color textColor;
  BookingContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(20),
          color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Text(
          title,
          style: myFont500.copyWith(color: textColor, fontSize: 18),
        ),
      ),
    );
  }
}
