import 'package:flutter/material.dart';
import 'package:wype_user/constants.dart';

AppBar commonAppbar(String title) {
  return AppBar(
    title: Text(
      title,
      style: myFont28_600,
    ),
  );
}
