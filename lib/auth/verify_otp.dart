// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:wype_user/constants.dart';

// import '../common/primary_button.dart';
// import '../services/firebase_services.dart';

// class VerifyOtp extends StatefulWidget {
//   String verificationId;
//   String contact;
//   bool isNewUser;
//   String? name;
//   String? gender;
//   VerifyOtp(
//       {super.key,
//       required this.verificationId,
//       required this.contact,
//       required this.isNewUser,
//       this.name,
//       this.gender});

//   @override
//   State<VerifyOtp> createState() => _VerifyOtpState();
// }

// class _VerifyOtpState extends State<VerifyOtp> {
//   TextEditingController otpCont = TextEditingController();
//   bool isLoading = false;
//   FirebaseService firebaseService = FirebaseService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: backgroundColor,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: height(context) * 0.06,
//             ),
//             InkWell(
//               borderRadius: BorderRadius.circular(30),
//               onTap: () => popNav(context),
//               child: Icon(
//                 Icons.chevron_left,
//                 size: 40,
//               ),
//             ),
//             40.height,
//             Text(
//               "Enter OTP",
//               style: GoogleFonts.readexPro(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: darkGradient),
//             ),
//             10.height,
//             Text(
//               "Sent to +91 ${widget.contact}",
//               style: GoogleFonts.readexPro(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey),
//             ),
//             50.height,
//             AppTextField(
//               isPassword: true,
//               suffix: Icon(
//                 Icons.visibility,
//                 color: Colors.grey,
//               ),
//               maxLength: 6,
//               controller: otpCont,
//               textStyle: GoogleFonts.readexPro(),
//               textFieldType: TextFieldType.NUMBER,
//               decoration: inputDecoration(context, labelText: "OTP"),
//             ),
//             50.height,
//             Align(
//               alignment: Alignment.center,
//               child: PrimaryButton(
//                   text: isLoading ? loaderText : "Log In",
//                   onTap: () async {
//                     if (otpCont.text.isEmpty || otpCont.text.length < 6) {
//                       toast("Enter valid OTP");
//                     } else {
//                       hideKeyboard(context);

//                       try {
//                         setState(() {
//                           isLoading = true;
//                         });
//                         await firebaseService.onOtpEntered(
//                             otpCont.text,
//                             widget.verificationId,
//                             context,
//                             widget.isNewUser,
//                             widget.name,
//                             widget.contact,
//                             widget.gender);
//                         setState(() {
//                           isLoading = false;
//                         });
//                       } catch (e) {
//                         setState(() {
//                           isLoading = false;
//                         });
//                         toast("OTP expired");
//                         Navigator.of(context).pop();
//                       }
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
