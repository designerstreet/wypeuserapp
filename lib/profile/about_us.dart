import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
        child: SafeArea(
      child: Scaffold(
        appBar: commonAppbar('About Wype'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Image.asset(
                logo,
                width: width(context) * 0.25,
              ),
              30.height,
              Text('')
            ],
          ),
        ),
      ),
    ));
  }
}
