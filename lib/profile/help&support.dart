import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/common_list_tile.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar('Help and support'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            commonListTile(
              title: '+97477337769',
              onTap: () {},
            ),
            20.height,
            commonListTile(
              title: 'Info@wypeqa.com',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
