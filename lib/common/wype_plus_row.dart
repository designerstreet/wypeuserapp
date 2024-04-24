import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

Row wypePlusRow(String cartTotal, String priceTotal, Function() onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cartTotal,
            style: myFont500.copyWith(color: Utils().blueDark),
          ),
          Text(
            '$priceTotal QAR',
            style: myFont28_600.copyWith(fontSize: 20, color: Utils().blueDark),
          ),
        ],
      ),
      TextButton(
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              backgroundColor: Utils().lightBlue),
          onPressed: onTap,
          child: Text(
            'select services'.toUpperCase(),
            style: myFont28_600.copyWith(color: white),
          ))
    ],
  );
}
