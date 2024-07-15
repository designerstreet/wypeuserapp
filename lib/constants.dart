import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/model/user_model.dart';

class Utils {
  var skyBlue = Colors.lightBlue;
  Color darkBlue = const Color.fromRGBO(49, 142, 208, 1);
  Color whiteColor = Colors.white;
  Color blueDark = const Color.fromRGBO(48, 57, 116, 1);
}

var myFont28_600 = TextStyle(
    fontFamily: 'ClashGrotesk',
    color: blackColor,
    fontSize: 16,
    fontWeight: FontWeight.w600);
var myFont500 = TextStyle(
    fontFamily: 'ClashGrotesk', color: blackColor, fontWeight: FontWeight.w500);

var blackColor = Colors.black;
// var grey = const Color.fromRGBO(153, 153, 153, 1);
var splashLogo = 'assets/images/splash_logo.png';
var loginLogo = 'assets/images/Logo-login.png';
var editImg = 'assets/images/edit.png';
var logoo = Image.asset('assets/images/logo.png');
var logo = 'assets/images/logo.png';

// Color whiteColor = Colors.white;
const screenBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(58, 192, 240, 0.3),
      Color.fromRGBO(58, 192, 240, 0),
    ]);
String onBoardingImg = 'assets/images/onboard.svg';
height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

const Color backgroundColor = Colors.white;
Color greyBg = Colors.grey.shade200;
Color iconColor = Colors.blue.shade800;

const loaderText = "• • •";

var lightGradient = HexColor("54B2CF");
var darkGradient = HexColor("0D1634");

width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

navigation(BuildContext context, Widget navigateTo, bool? isRoot) {
  return Navigator.of(context, rootNavigator: isRoot ?? false).push(
    PageTransition(
        type: PageTransitionType.fade,
        isIos: false,
        duration: const Duration(milliseconds: 200),
        child: navigateTo),
  );
}

popNav(BuildContext context) {
  return Navigator.of(context).pop();
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon, String? labelText, double? borderRadius}) {
  return InputDecoration(
    contentPadding:
        const EdgeInsets.only(left: 12, bottom: 15, top: 15, right: 10),
    counterText: "",
    labelText: labelText,
    labelStyle: GoogleFonts.readexPro(color: Colors.grey.shade400),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: lightGray, width: 0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: GoogleFonts.readexPro(color: Colors.red, fontSize: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: lightGradient, width: 1.0),
    ),
    filled: true,
    fillColor: context.cardColor,
  );
}

Widget primaryButton(String text) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(35),
      color: darkGradient,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
    child: Text(
      text,
      style: GoogleFonts.readexPro(color: Colors.white),
    ),
  );
}

// List<String> models = ["BMW", "Audi"];

List<String> topServices = [
  "assets/icons/wash.png",
  "assets/icons/Interior Clean.png",
  "assets/icons/Polish.png",
  "assets/icons/Tire Dressing.png",
  "assets/icons/Engine Wash.png",
  "assets/icons/Spray.png",
  "assets/icons/Blower.png",
  "assets/icons/Carpet Clean.png",
];

String getAssetName(String fullPath) {
  // Split the path using the '/' separator
  List<String> pathSegments = fullPath.split('/');

  // The last segment will be the asset name
  String assetName = pathSegments.last;

  return assetName;
}

List<String> timings = [
  "9:00 AM",
  "9:30 AM",
  "10:00 AM",
  "Unavailable",
  "11:00 AM",
  "Unavailable",
  "12:00 PM",
  "1:00 PM",
  "2:00 PM",
  "Unavailable",
  "3:00 PM",
  "4:00 PM",
  "Unavailable",
  "Unavailable",
];
List<String> reSchedule = ["12 hrs", "24 hrs"];

UserModel? userData;

PromoCodes? promoCodeModel;

// List of car brands
List<String> carBrands = [];

// Map to store car models for each brand
Map<String, List<String>> carModels = {};

List<Package> subscriptionPackage = [];

String testKey = "sk_test_63b66c8b26cd58f96f7e69d6c21781439169";
String liveKey = "sk_live_7936d2d1644ba8db60d5e9dc9240132f4528";
