import 'package:flutter/material.dart';
import 'package:wype_user/constants.dart';

void profileDialog(context, String title, String content, String tag,
    Function()? onTap) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.start,
          style: myFont28_600.copyWith(fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'cancel'.toUpperCase(),
                      style: myFont28_600.copyWith(color: Utils().lightBlue),
                    )),
                TextButton(
                    onPressed: () {
                      onTap?.call();
                      Navigator.pop(context);
                    },
                    child: Text(
                      tag.toUpperCase(),
                      style: myFont28_600.copyWith(color: Utils().lightBlue),
                    )),
              ],
            ),
          ],
        ),
      );
    },
  );
}
