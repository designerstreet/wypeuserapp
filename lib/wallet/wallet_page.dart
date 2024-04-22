import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/provider/language.dart';

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
  TextEditingController depositCont = TextEditingController();
  bool isLoading = false;
  setLoader(bool val) {
    isLoading = val;
    setState(() {});
  }

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
                  userLang.isAr ? "محفظة" : "Wallet",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightGradient),
                ),
              ],
            ),
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userLang.isAr ? "الرصيد المتوفر: " : "Available balance: ",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGradient.withOpacity(0.6)),
                ),
                Text(
                  "${userData?.wallet.toString() ?? "0"} QR",
                  style: GoogleFonts.readexPro(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkGradient),
                ),
              ],
            ),
            25.height,
            AppTextField(
              controller: depositCont,
              textStyle: GoogleFonts.readexPro(),
              textFieldType: TextFieldType.NUMBER,
              decoration: inputDecoration(context,
                  labelText:
                      userLang.isAr ? "أضف مبلغ المحفظة" : "Add Wallet Amount"),
            ),
            50.height,
            Align(
              alignment: Alignment.center,
              child: PrimaryButton(
                  text: userLang.isAr ? "يتأكد" : "Confirm",
                  onTap: () async {
                    setLoader(true);
                    try {
                      PaymentModel? paymentRes = await createPayment(
                          depositCont.text.toDouble(), "Wallet Deposit");
                      setLoader(false);

                      if (paymentRes != null) {
                        navigation(
                            context,
                            DibsyWebview(
                                saveLocation: false,
                                url: paymentRes.links!.checkout!.href!,
                                id: paymentRes.id!,
                                amount: depositCont.text.toDouble(),
                                booking: null),
                            true);
                      }
                    } catch (e) {
                      toast(userLang.isAr
                          ? "هناك خطأ ما"
                          : "Something went wrong");
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
