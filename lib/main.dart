import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/home/root.dart';
import 'package:wype_user/new_onboard/onboarding_screen.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';
import 'auth/login_page.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await Stripe.instance.applySettings();
  // await dotenv.load(fileName: "assets/.env");
  runApp(ChangeNotifierProvider(
      create: (context) => UserLang(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wype',
      theme: ThemeData(
        fontFamily: 'ClashGrotesk',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    route();
  }

  route() async {
    userData = await firebaseService.getUserDetails();
    // bookingDetail = await firebaseService.getBookingData();
    if (userData == null) {
      Timer(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const OnBoardingScreen(),
            ),
            (route) => false);
      });
    } else {
      Get.off(const RootPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        height: height(context),
        width: width(context),
        child: Center(
          child: Image(
            image: const AssetImage('assets/images/logo.png'),
            fit: BoxFit.contain,
            width: width(context) * 0.5,
          ),
        ),
      ),
    );
  }
}
