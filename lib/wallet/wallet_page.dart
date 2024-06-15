import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/wallet/add_bal_page.dart';

import '../booking/dibsy_webview.dart';
import '../common/primary_button.dart';
import '../constants.dart';
import '../model/dibsy_res.dart';
import '../services/payment_services.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userLang.isAr ? "محفظة" : "My Wallet",
          style: myFont28_600,
        ),
      ),
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(28, 32, 52, 1),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'wype money',
                          style: myFont500.copyWith(
                              color: Utils().lightGray, fontSize: 16),
                        ),
                        Text("${userData?.wallet.toString() ?? "0.00"} QAR",
                            style: myFont28_600.copyWith(
                                color: white, fontSize: 28)),
                      ],
                    ),
                    TextButton.icon(
                        icon: const Icon(
                          Icons.add,
                          color: white,
                        ),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: Utils().lightBlue),
                        onPressed: () {
                          const AddBalence().launch(context);
                        },
                        label: Text(
                          'add balance'.toUpperCase(),
                          style: myFont28_600.copyWith(color: white),
                        ))
                  ],
                ),
              ),
            ),
            25.height,
          ],
        ),
      ),
    );
  }
}
