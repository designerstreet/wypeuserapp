import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wype_user/model/add_service_model.dart';
import 'package:wype_user/model/booking.dart';
import 'package:wype_user/model/package_model.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/model/user_model.dart';

class Utils {
  var skyBlue = Colors.lightBlue;
  Color lightBlue = const Color.fromRGBO(49, 142, 208, 1);
  Color whiteColor = Colors.white;
  Color blueDark = const Color.fromRGBO(48, 57, 116, 1);
  Color lightGray = const Color.fromRGBO(255, 255, 255, 1);
  Color softBlue = const Color.fromRGBO(225, 242, 242, 1);
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
var bookCar = 'assets/images/bookcar.png';
var logo = 'assets/images/logo.png';
var profieLogo = 'assets/images/profile.png';
var walletLogo = 'assets/images/wallet.png';
var addressLogo = 'assets/images/address.png';
var aboutLogo = 'assets/images/about.png';
var workLogo = 'assets/images/work.png';
var helpLogo = 'assets/images/help.png';
var logoutLogo = 'assets/images/logout.png';
var notiLogo = 'assets/images/noti.png';

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
var darkGradient = HexColor("1C2034");
var greyLight = HexColor('D4D4D4');
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
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    child: Text(
      text,
      style: myFont500.copyWith(color: white),
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

TextEditingController dob = TextEditingController();
void datePicker(context) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1947),
      lastDate: DateTime(2101));
  if (pickedDate != null) {
    log(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
    String formattedDate = DateFormat('yyyy-MM-dd').format(
        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
    log(formattedDate); //formatted date output using intl package =>  2022-07-04
    //You can format date as per your need

    dob.text = formattedDate; //set foratted date to TextField value.
  } else {
    log("Date is not selected");
  }
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
String startTime = "6:00";
String endTime = "1:30";

var timeList = [
  '4:00 - 6:00',
  '6:00 - 1:00',
  '6:30  - 2:00',
  '7:00 - 3:00',
  '7:30 - 4:00',
  '8:00 - 4:30',
  '8:30 - 5:00',
  '9:00 - 5:30',
  '9:30 - 6:00',
  '10:00 - 6:30',
  '10:30 - 7:00',
  '11:00 - 7:30',
  '11:30 - 8:00',
  '12:00 - 8:30',
  '12:30 - 9:00',
];

// var totalTimeList = startTimeList + endTimeList;
List<String> reSchedule = ["12 hrs", "24 hrs"];

UserModel? userData;
BookingModel? bookingDetail;
PromoCodes? promoCodeModel;

// List of car brands
List<String> carBrands = [];

// Map to store car models for each brand
Map<String, List<String>> carModels = {};

List<Package> subscriptionPackage = [];
// List<ServiceModel> serviceModel = [];
// List services = [];
String testKey = "sk_test_63b66c8b26cd58f96f7e69d6c21781439169";
String liveKey = "sk_live_7936d2d1644ba8db60d5e9dc9240132f4528";
