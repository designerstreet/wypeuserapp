import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeIn(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tick.png',
              height: height(context) * 0.2,
            ),
            Text(
              'Sit Back and Relax',
              style: myFont28_600.copyWith(fontSize: 25),
            ),
            const Text('You payment was completed Successfully!'),
            20.height,
            PrimaryButton(
              text: 'my booking',
              onTap: () {},
            ),
            TextButton(
                onPressed: () {},
                child: Text(
                  'download receipt'.toUpperCase(),
                  style: myFont28_600.copyWith(color: Utils().lightBlue),
                ))
          ],
        ),
      )),
    );
  }
}
