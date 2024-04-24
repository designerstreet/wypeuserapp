import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wype_user/common/add_remove_widget.dart';
import 'package:wype_user/common/wype_plus_container.dart';
import 'package:wype_user/constants.dart';

class CustomService extends StatefulWidget {
  const CustomService({super.key});

  @override
  State<CustomService> createState() => _CustomServiceState();
}

class _CustomServiceState extends State<CustomService> {
  int counter = 0;
  void add() {
    setState(() {
      counter++;
    });
  }

  void dec() {
    setState(() {
      counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Service',
          style: myFont28_600,
        ),
      ),
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (counter ==0)
            PlusContainer(
                widget: Container(
                  decoration: BoxDecoration(
                      color: Utils().softBlue,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Utils().lightBlue)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            dec();
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.minus,
                            size: 15,
                            color: Utils().blueDark,
                          )),
                      Text(
                        counter.toString(),
                        textAlign: TextAlign.center,
                        style: myFont28_600.copyWith(
                          color: Utils().lightBlue,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            add();
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Utils().blueDark,
                            size: 15,
                          )),
                    ],
                  ),
                ),
                img: 'assets/images/deepclean.png',
                washTitle: 'Interior Glass',
                priceTitle: '30 QAR',
                isSelected: false)
          ],
        ),
      )),
    ));
  }
}
