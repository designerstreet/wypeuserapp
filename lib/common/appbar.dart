import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

AppBar commonAppbar(String title) {
  return AppBar(
    backgroundColor: white,
    surfaceTintColor: white,
    title: Text(
      title,
      style: myFont28_600,
    ),
  );
}
