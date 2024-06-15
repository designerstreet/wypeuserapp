import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/booking/dibsy_webview.dart';
import 'package:wype_user/common/appbar.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/dibsy_res.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/payment_services.dart';

class AddBalence extends StatefulWidget {
  const AddBalence({super.key});

  @override
  State<AddBalence> createState() => _AddBalenceState();
}

class _AddBalenceState extends State<AddBalence> {
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
      appBar: commonAppbar('wallet'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            AppTextField(
              controller: depositCont,
              textStyle: myFont500,
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

                      navigation(
                          context,
                          DibsyWebview(
                              saveLocation: false,
                              url: paymentRes!.links!.checkout!.href!,
                              id: paymentRes.id!,
                              amount: depositCont.text.toDouble(),
                              booking: null),
                          true);
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
