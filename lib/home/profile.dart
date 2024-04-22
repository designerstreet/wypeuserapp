import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/common/profile_container.dart';
import 'package:wype_user/home/settings.dart';
import 'package:wype_user/profile/address_list.dart';
import 'package:wype_user/profile/points_page.dart';
import 'package:wype_user/profile/promo_codes.dart';
import 'package:wype_user/profile/saved_locations.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/wallet/wallet_page.dart';

import '../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: height(context) * 0.08,
            ),
            Container(
              height: height(context) * 0.13,
              width: height(context) * 0.13,
              decoration: BoxDecoration(
                  border: Border.all(color: darkGradient),
                  color: white,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: Center(
                child: Text(
                  userData?.name.capitalizeFirstLetter().substring(0, 1) ?? "T",
                  style: GoogleFonts.readexPro(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: darkGradient),
                ),
              ),
            ),
            20.height,
            Align(
              alignment: Alignment.center,
              child: Text(
                userData?.name.capitalizeFirstLetter() ?? "",
                style: GoogleFonts.readexPro(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkGradient),
              ),
            ),
            40.height,
            ProfileContainer(
                onTap: () => const SavedLocationPage().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                icon: FontAwesomeIcons.wallet,
                subText: null,
                text: userLang.isAr ? "الموقع المحفوظ" : "Saved Location"),
            10.height,
            ProfileContainer(
                onTap: () => const WalletPage().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                icon: FontAwesomeIcons.wallet,
                subText: userData?.wallet == null
                    ? null
                    : "${userData?.wallet.toString()} QR",
                text: userLang.isAr ? "محفظة" : "Wallet"),
            10.height,
            ProfileContainer(
                // ignore: prefer_null_aware_operators
                subText: userData?.points == null
                    ? null
                    : userData?.points.toString(),
                onTap: () => const PointsPage().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                icon: FontAwesomeIcons.coins,
                text: userLang.isAr ? "نقاطي" : "My Points"),
            10.height,

            ProfileContainer(
                onTap: () => const PromoCodes().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                icon: FontAwesomeIcons.qrcode,
                text: userLang.isAr ? "الرموز الترويجية" : "Promo Codes"),
            // 10.height,
            // ProfileContainer(
            //     onTap: () => AddressList().launch(context,
            //         pageRouteAnimation: PageRouteAnimation.Fade),
            //     icon: FontAwesomeIcons.locationArrow,
            //     text: "Saved Address"),
            10.height,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: height(context) * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: darkGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  10.width,
                  Icon(
                    FontAwesomeIcons.language,
                    color: lightGradient,
                    size: 18,
                  ),
                  15.width,
                  Text(
                    userLang.isAr ? "لغة" : "Language",
                    style: GoogleFonts.readexPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: darkGradient),
                  ),
                  const Spacer(),
                  const Text("En"),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      trackColor: darkGradient,
                      activeColor: darkGradient,
                      value: userLang.isAr,
                      onChanged: (bool value) {
                        if (value) {
                          userLang.changeLanguage('ar');
                        } else {
                          userLang.changeLanguage('en');
                        }
                      },
                    ),
                  ),
                  const Text("Ar"),
                ],
              ),
            ),
            10.height,
            ProfileContainer(
                onTap: () => const SettingPage().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                icon: FontAwesomeIcons.cogs,
                text: userLang.isAr ? "إعدادات" : "Settings"),

            10.height,
          ],
        ),
      ),
    );
  }
}
