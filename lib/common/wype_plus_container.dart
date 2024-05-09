import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class PlusContainer extends StatefulWidget {
  var img;
  bool isSelected;
  int? oneWashIndex;
  String washTitle;
  String priceTitle;
  String? disPrice;
  String? per;
  Widget? widget;

  PlusContainer(
      {Key? key,
      this.oneWashIndex,
      required this.img,
      required this.washTitle,
      required this.priceTitle,
      this.disPrice,
      required this.isSelected,
      this.widget,
      this.per})
      : super(key: key);

  @override
  State<PlusContainer> createState() => _PlusContainerState();
}

class _PlusContainerState extends State<PlusContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: widget.isSelected ? Utils().lightBlue : gray,
              width: widget.isSelected ? 2 : 0),
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              widget.img,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.washTitle,
                    style: myFont500.copyWith(
                        color: Utils().blueDark, fontSize: 16),
                  ),
                  Text("${widget.priceTitle} QAR",
                      style: myFont28_600.copyWith(
                          color: Utils().blueDark, fontSize: 28)),
                  Row(
                    children: [
                      Text(
                        widget.disPrice != null
                            ? "${widget.disPrice} QAR" ?? 'No Discount'
                            : '',
                        style: myFont28_600.copyWith(color: grey, fontSize: 20),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            widget.disPrice != null ? 'save'.toUpperCase() : '',
                            style:
                                myFont28_600.copyWith(color: Utils().skyBlue),
                          ),
                          Text(
                            widget.disPrice != null ? widget.per ?? '0%' : '',
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
          ],
        ),
      ),
    );
  }
}
