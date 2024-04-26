import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/common/profile_container.dart';
import 'package:wype_user/common/profile_dialog.dart';
import 'package:wype_user/home/settings.dart';
import 'package:wype_user/model/faq_model.dart';
import 'package:wype_user/profile/about_us.dart';
import 'package:wype_user/profile/address_list.dart';
import 'package:wype_user/profile/points_page.dart';
import 'package:wype_user/profile/promo_codes.dart';
import 'package:wype_user/profile/saved_locations.dart';
import 'package:wype_user/profile/update_profile.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/wallet/wallet_page.dart';

import '../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: transparentColor,
      body: FadeIn(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Utils().blueDark,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  userData?.name.capitalizeFirstLetter() ?? "",
                                  style: myFont28_600.copyWith(
                                      color: white, fontSize: 30)),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                  userData?.contact.capitalizeFirstLetter() ??
                                      "",
                                  style: myFont28_600.copyWith(color: white)),
                            ),
                          ],
                        ),
                        10.height,
                        Container(
                          height: height(context) * 0.10,
                          width: height(context) * 0.10,
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
                              userData?.name
                                      .capitalizeFirstLetter()
                                      .substring(0, 1) ??
                                  "T",
                              style: GoogleFonts.readexPro(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: darkGradient),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.50,
                      color: Utils().whiteColor,
                    ),
                    15.height,
                    Text(
                      'Current Subscription : ${bookingDetail?.bookingStatus ?? 'No Active Plan'}',
                      style: myFont500.copyWith(
                          color: Utils().lightGray, fontSize: 18),
                    ),
                    10.height,
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: lightSlateGrey,
                          image: const DecorationImage(
                            scale: 5,
                            alignment: Alignment.bottomRight,
                            image: AssetImage(
                              'assets/images/promo.png',
                            ),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'You have multiple\npromos',
                          style: myFont28_600.copyWith(color: white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            20.height,

            ProfileContainer(
                onTap: () => UpdateProfile(
                      name: userData!.name.toString(),
                      number: userData!.contact.toString(),
                    ).launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade),
                icon: profieLogo,
                subText: null,
                text: userLang.isAr ? "الموقع المحفوظ" : "My Profile"),
            10.height,
            ProfileContainer(
              onTap: () => const WalletPage()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade),
              icon: walletLogo,
              // subText: userData?.wallet == null
              //     ? null
              //     : "${userData?.wallet.toString()} QR",
              text: userLang.isAr ? "محفظة" : " My Wallet",
            ),
            10.height,
            ProfileContainer(
                onTap: () {}, icon: addressLogo, text: 'Addresses'),

            10.height,

            ProfileContainer(
                onTap: () => const AboutUs().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                // onTap: () => const PromoCodes().launch(context,
                //     pageRouteAnimation: PageRouteAnimation.Fade),
                icon: aboutLogo,
                text: userLang.isAr ? "الرموز الترويجية" : "About Wype"),

            10.height,
            ProfileContainer(
                onTap: () => const SettingPage().launch(context,
                    pageRouteAnimation: PageRouteAnimation.Fade),
                icon: workLogo,
                text: userLang.isAr ? "إعدادات" : "How It Works"),

            10.height,
            ProfileContainer(
                onTap: () {}, icon: notiLogo, text: 'Notification Settings'),
            10.height,
            ProfileContainer(
                onTap: () {}, icon: helpLogo, text: 'Help & Support'),
            ProfileContainer(
                onTap: () {
                  profileDialog(
                      context, 'Logout from Wype', 'Are you sure?', 'Logout',
                      () {
                    auth.signOut();
                    // navigation(context, const LoginPage(), false);
                  });
                },
                icon: logoutLogo,
                text: 'Logout')
            // ProfileContainer(
            //     onTap: () => AddressList().launch(context,
            //         pageRouteAnimation: PageRouteAnimation.Fade),
            //     icon: FontAwesomeIcons.locationArrow,
            //     text: "Saved Address"),
            // ProfileContainer(
            //     // ignore: prefer_null_aware_operators
            //     subText: userData?.points == null
            //         ? null
            //         : userData?.points.toString(),
            //     onTap: () => const PointsPage().launch(context,
            //         pageRouteAnimation: PageRouteAnimation.Fade),
            //     icon: FontAwesomeIcons.coins,
            //     text: userLang.isAr ? "نقاطي" : "My Points"),
          ],
        ),
      ),
    );
  }
}
