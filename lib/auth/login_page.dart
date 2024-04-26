import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/auth/register_page.dart';
import 'package:wype_user/common/file_view.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignIn = true;
  bool isMale = true;
  bool isAgree = false;
  bool isLoading = false;
  FirebaseService firebaseService = FirebaseService();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height(context) * 0.06,
              ),
              Center(
                child: Image.asset(
                  loginLogo,
                  height: height(context) * 0.08,
                ),
              ),
              SizedBox(
                height: height(context) * 0.05,
              ),
              Center(
                child: Text(
                  'Login ',
                  style: myFont28_600.copyWith(
                      fontSize: 28, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: height(context) * 0.05,
              ),
              Center(
                child: Text('Continue with your mobile number',
                    style: myFont28_600.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              ),
              SizedBox(
                height: height(context) * 0.05,
              ),

              LoginFiled(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter correct number';
                    }
                    return null;
                  },
                  lableText: '+974 |   ',
                  keyBord: TextInputType.phone,
                  isObsecure: false,
                  prefixText: '+974 |   ',
                  controller: emailCont,
                  hintText: 'Phone Number'),
              // Row(
              //   children: [
              //     InkWell(
              //       splashColor: Colors.transparent,
              //       highlightColor: Colors.transparent,
              //       onTap: () => setState(() {
              //         isSignIn = true;
              //       }),
              //       child: Column(
              //         children: [
              //           Text(
              //             userLang.isAr ? "تسجيل الدخول" : "Sign In",
              //             style: GoogleFonts.readexPro(
              //                 fontSize: 20, fontWeight: FontWeight.w500),
              //           ),
              //           4.height,
              //           isSignIn
              //               ? Container(
              //                   height: 4,
              //                   width: width(context) * 0.2,
              //                   color: lightGradient,
              //                 )
              //               : Container(
              //                   height: 4,
              //                 ),
              //         ],
              //       ),
              //     ),
              //     30.width,
              //     InkWell(
              //       splashColor: Colors.transparent,
              //       highlightColor: Colors.transparent,
              //       onTap: () => setState(() {
              //         isSignIn = false;
              //       }),
              //       child: Column(
              //         children: [
              //           Text(
              //             userLang.isAr ? "التسجيل" : "Sign Up",
              //             style: GoogleFonts.readexPro(
              //                 fontSize: 20, fontWeight: FontWeight.w500),
              //           ),
              //           4.height,
              //           isSignIn
              //               ? Container(
              //                   height: 4,
              //                 )
              //               : Container(
              //                   height: 4,
              //                   width: width(context) * 0.2,
              //                   color: lightGradient,
              //                 ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

              20.height,
              LoginFiled(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                  keyBord: TextInputType.visiblePassword,
                  isObsecure: true,
                  controller: passCont,
                  hintText: 'Password'),
              20.height,
              Text(
                'Forgot Password ?',
                style: myFont28_600.copyWith(
                    color: Utils().skyBlue, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 30,
              ),
              PrimaryButton(
                text: 'LOGIN',
                onTap: () async {
                  if (emailCont.text.isEmpty || passCont.text.isEmpty) {
                    toast(userLang.isAr
                        ? "أدخل بيانات اعتماد صالحة"
                        : "Enter valid credentials");
                  } else {
                    hideKeyboard(context);
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await firebaseService.login(
                          context,
                          false,
                          null,
                          null,
                          emailCont.text,
                          null,
                          passCont.text,
                          userLang.isAr ? "ar" : "en");
                    } catch (e) {
                      toast(userLang.isAr
                          ? "بيانات الاعتماد غير صالحة"
                          : "Invalid credentials");
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ),

              //           Align(
              //             alignment: Alignment.center,
              //             child: PrimaryButton(
              //                 text: isLoading
              //                     ? loaderText
              //                     : userLang.isAr
              //                         ? "التسجيل"
              //                         : "Sign Up",
              //                 onTap: () async {
              //                   if (nameCont.text.isEmpty ||
              //                       emailCont.text.isEmpty ||
              //                       passCont.text.isEmpty) {
              //                     toast(userLang.isAr
              //                         ? "أدخل مدخلات صالحة"
              //                         : "Enter valid inputs");
              //                   } else if (!isAgree) {
              //                     toast(userLang.isAr
              //                         ? "يرجى التحقق من الشروط والأحكام"
              //                         : "Please check T&C");
              //                   } else {
              //                     try {
              //                       setState(() {
              //                         isLoading = true;
              //                       });
              //                       await firebaseService.login(
              //                           context,
              //                           true,
              //                           nameCont.text,
              //                           emailCont.text,
              //                           isMale ? "Male" : "Female",
              //                           passCont.text,
              //                           userLang.isAr ? "ar" : "en");

              //                       setState(() {
              //                         isLoading = false;
              //                       });
              //                     } catch (e) {
              //                       toast(e.toString());
              //                       setState(() {
              //                         isLoading = false;
              //                       });
              //                     }
              //                   }
              //                 }),
              //           ),
              //         ],
              //       )
            ],
          ),
        ),
      ),
    );
  }
}
