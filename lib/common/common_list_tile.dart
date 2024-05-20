import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class commonListTile extends StatelessWidget {
  String title;
  Function() onTap;
  commonListTile({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        // contentPadding: EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: lightGray),
            borderRadius: BorderRadius.all(Radius.circular(10))),

        title: Text(
          title,
          // ignore: deprecated_member_use
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: gray,
        ),
      ),
    );
  }
}
