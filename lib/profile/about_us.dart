// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/common_list_tile.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                logo,
                width: width(context) * 0.25,
              ),
              30.height,
              Text(
                'Anytime, Anywhere, will be there!',
                style: myFont28_600,
              ),
              20.height,
              const Text('''

The first sustainable and Eco-friendly car cleaning App Company in Qatar! We help our
community with minimal water usage and environmentally friendly products for our
services. Our team is composed of the most experienced professionals committed to
offer the finest customer service to ensure you enjoy the journey.Offering you
subscriptions within our application and distinct payment methods.'''),
              20.height,
              commonListTile(
                title: 'Terms of Service',
                onTap: () {},
              ),
              20.height,
              commonListTile(
                title: 'Privacy Policy',
                onTap: () {},
              ),
              20.height,
              commonListTile(
                title: 'Licenses and Registrations',
                onTap: () {},
              ),
              30.height,
              const Text('App Version'),
              const Text('v1.2 Live')
            ],
          ),
        ),
      ),
    ));
  }
}
