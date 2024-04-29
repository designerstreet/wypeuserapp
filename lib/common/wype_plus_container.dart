import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class PlusContainer extends StatelessWidget {
  var img;
  bool isSelected = false;
  String washTitle;
  String priceTitle;
  String? disPrice;
  String? per;
  Widget? widget;

  PlusContainer(
      {Key? key,
      required this.img,
      required this.washTitle,
      required this.priceTitle,
      this.disPrice,
      required this.isSelected,
      this.widget,
      this.per})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? gray : Utils().lightBlue,
              width: isSelected ? 2 : 0),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              img,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    washTitle,
                    style: myFont500.copyWith(
                        color: Utils().blueDark, fontSize: 16),
                  ),
                  Text("$priceTitle QAR",
                      style: myFont28_600.copyWith(
                          color: Utils().blueDark, fontSize: 28)),
                  Row(
                    children: [
                      Text(
                        disPrice != null
                            ? "$disPrice QAR" ?? 'No Discount'
                            : '',
                        style: myFont28_600.copyWith(color: grey, fontSize: 20),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            disPrice != null ? 'save'.toUpperCase() : '',
                            style:
                                myFont28_600.copyWith(color: Utils().skyBlue),
                          ),
                          Text(
                            disPrice != null ? per ?? '0%' : '',
                            style:
                                myFont28_600.copyWith(color: Utils().skyBlue),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            widget ?? Container()
          ],
        ),
      ),
    );
  }
}
