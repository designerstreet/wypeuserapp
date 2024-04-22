import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/provider/language.dart';

class PointsPage extends StatefulWidget {
  const PointsPage({super.key});

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: height(context) * 0.07,
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => popNav(context),
                  child: Icon(
                    Icons.chevron_left,
                    size: 29,
                    color: lightGradient,
                  ),
                ),
                10.width,
                Text(
                  userLang.isAr ? "نقاط" : "Points",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightGradient),
                ),
              ],
            ),
            30.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userLang.isAr ? "النقاط المتاحة: " : "Available points: ",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGradient.withOpacity(0.6)),
                ),
                Text(
                  userData?.points.toString() ?? "0",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGradient),
                ),
              ],
            ),
            25.height,
            AppTextField(
              textStyle: GoogleFonts.readexPro(),
              textFieldType: TextFieldType.NUMBER,
              decoration: inputDecoration(context,
                  labelText: userLang.isAr
                      ? "استبدال النقاط إلى المحفظة"
                      : "Redeem Points to Wallet"),
            ),
            50.height,
            Align(
              alignment: Alignment.center,
              child: PrimaryButton(
                  text: userLang.isAr ? "يسترد" : "Redeem",
                  onTap: () => popNav(context)),
            ),
          ],
        ),
      ),
    );
  }
}
