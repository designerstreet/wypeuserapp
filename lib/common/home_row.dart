import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class HomeRow extends StatelessWidget {
  String title;
  String subTitle;
  String subText;
  var titleImage;
  var subImage;
  var subTextImage;
  HomeRow({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.subText,
    required this.titleImage,
    required this.subImage,
    required this.subTextImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              Image.asset(
                titleImage.toString(),
                height: height(context) * 0.065,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Image.asset(
                subImage.toString(),
                height: height(context) * 0.065,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Image.asset(
                subTextImage.toString(),
                height: height(context) * 0.065,
              ),
              Text(
                subText,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ],
    );
  }
}
