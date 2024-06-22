import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/home/home_plain.dart';
import 'package:wype_user/profile/profile.dart';
import 'package:wype_user/my_booking/my_booking_new.dart';
import 'package:wype_user/subscription_screens/add_vehicle.dart';

import 'package:wype_user/provider/language.dart';

import '../constants.dart';
import '../services/firebase_services.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser(context);
  }

  setLoader(bool val) {
    isLoading = val;
    setState(() {});
  }

  getCurrentUser(context) async {
    userData = await firebaseService.getUserDetails();

    if (userData == null) {
      const LoginPage()
          .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    } else {
      promoCodeModel = await firebaseService.getPromoCodes();
      await firebaseService.getVehicles();
      await firebaseService.getAllPackagesFromFirestore();
      await firebaseService.getBookingData();
      setLoader(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    List<Widget> screens() {
      return [
        const PlainHome(),
        AddVehiclePage(
          isFromHome: true,
          saveLocation: false,
        ),
        MyBooking(
          address: bookingDetail?.address.toString(),
        ),
        const ProfilePage(),
      ];
    }

    List<PersistentBottomNavBarItem> navBarItems = [
      PersistentBottomNavBarItem(
        title: (userLang.isAr) ? "الرئيسية" : "Home",
        icon: const Icon(
          FontAwesomeIcons.house,
          size: 20,
        ),
        textStyle: GoogleFonts.lato(fontSize: 12),
        activeColorPrimary: darkGradient,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        title: (userLang.isAr) ? "المركبات" : "Vehicles",
        icon: const Icon(
          FontAwesomeIcons.car,
          size: 20,
        ),
        textStyle: GoogleFonts.lato(fontSize: 12),
        activeColorPrimary: darkGradient,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        title: (userLang.isAr) ? "الحجوزات" : "Bookings",
        icon: const Icon(
          FontAwesomeIcons.clock,
          size: 20,
        ),
        textStyle: GoogleFonts.lato(fontSize: 12),
        activeColorPrimary: darkGradient,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        title: (userLang.isAr) ? "ملفي الشخصي" : "Profile",
        icon: const Icon(
          Icons.person,
          size: 25,
        ),
        textStyle: GoogleFonts.lato(fontSize: 12),
        activeColorPrimary: darkGradient,
        inactiveColorPrimary: Colors.grey,
      ),
    ];

    PersistentTabView buildScreens() {
      return PersistentTabView(context, controller: controller,
          onItemSelected: (val) {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
          items: navBarItems,
          backgroundColor: Colors.white,
          screens: screens(),
          navBarStyle: NavBarStyle.style8);
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: darkGradient,
              ),
            )
          : buildScreens(),
    );
  }
}
