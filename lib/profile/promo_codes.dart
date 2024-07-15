import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/onBoarding/add_address.dart';
import 'package:wype_user/provider/language.dart';

class PromoCodes extends StatefulWidget {
  const PromoCodes({super.key});

  @override
  State<PromoCodes> createState() => _PromoCodesState();
}

class _PromoCodesState extends State<PromoCodes> {
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeIn(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
                    userLang.isAr ? "الرموز الترويجية" : "Promo Codes",
                    style: GoogleFonts.readexPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: lightGradient),
                  ),
                ],
              ),
              30.height,
              ((promoCodeModel?.promoCodes != null) &&
                      (promoCodeModel?.promoCodes?.isNotEmpty ?? false))
                  ? Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemCount: promoCodeModel?.promoCodes?.length ?? 0,
                          itemBuilder: (_, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: darkGradient)),
                              height: height(context) * 0.1,
                              width: width(context),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        promoCodeModel
                                                ?.promoCodes?[index].name ??
                                            "N/A",
                                        style: GoogleFonts.readexPro(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: darkGradient),
                                      ),
                                      Text(
                                        promoCodeModel
                                                ?.promoCodes?[index].subtitle ??
                                            "N/A",
                                        style: GoogleFonts.readexPro(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: darkGradient),
                                      ),
                                    ],
                                  )),
                                  20.width,
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () => navigation(
                                        context,
                                        AddAddressPage(
                                          promoCode: promoCodeModel
                                              ?.promoCodes?[index],
                                          isFromHome: true,
                                        ),
                                        true),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5.0,
                                                offset: Offset(-2, 5)),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: darkGradient),
                                      child: Center(
                                        child: Text(
                                          userLang.isAr ? "يتقدم" : "Apply",
                                          style: GoogleFonts.readexPro(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 108.0),
                      child: Text(
                        userLang.isAr
                            ? "لا توجد رموز ترويجية متاحة في الوقت الراهن"
                            : "No Promo Codes available at the moment",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: darkGradient),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
