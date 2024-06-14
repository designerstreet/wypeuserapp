import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List onboardImg = [
    'assets/images/on1.png',
    'assets/images/on2.png',
    'assets/images/on3.png',
    'assets/images/on4.png',
  ];
  List onText = [
    'Select Your Location',
    'Choose Your Vehicle',
    'Book a Slot',
    'Sit Back and Relax!'
  ];
  List detailsText = [
    'Select your current location, our experts will pick up your car.',
    'Choose from existing vehicle or add a vehicle',
    'Choose date and time for your selected subscription.',
    'Your car will be picked up, washed and delivered to your doorstep.'
  ];
  final pageController = PageController(initialPage: 0);
  int currentPage = 0;
  int recentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
    decoration: const BoxDecoration(gradient: screenBackground),
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 23),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              logo,
              height: 50,
            ),
            TextButton(
                onPressed: () {
                  navigation(context, const LoginPage(), false);
                },
                child: Text(
                  'skip'.toUpperCase(),
                  style: myFont28_600.copyWith(
                      fontSize: 16, color: Colors.grey),
                ))
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Expanded(
        child: PageView.builder(
          onPageChanged: (int page) {
            setState(() {
              currentPage = page;
              recentPage = page;
            });
          },
          controller: pageController,
          pageSnapping: true,
          itemCount: onboardImg.length,
          physics: const ScrollPhysics(),
          scrollBehavior: const ScrollBehavior(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(onboardImg[index]),
                  SizedBox(
                    height: height(context) * 0.02,
                  ),
                  Text(
                    onText[index],
                    style: myFont28_600.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 28),
                  ),
                  // SizedBox(
                  //   height: height(context) * 0.02,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Text(
                      detailsText[index],
                      overflow: TextOverflow.fade,
                      style: myFont28_600.copyWith(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                  // SizedBox(
                  //   height: height(context) * 0.1,
                  // ),
                ],
              ),
            );
          },
        ),
      ),
      // const Spacer(),
    
      DotsIndicator(
        dotsCount: 4,
        position: currentPage,
        decorator: DotsDecorator(
          size: const Size(7.0, 6.5),
          activeSize: const Size(30.0, 7.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
          color: gray,
          activeColor: Utils().skyBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    
      SizedBox(
        width: height(context) * 0.22,
        child: PrimaryButton(
          text: currentPage == 3 ? 'GET STARTED' : 'NEXT',
          onTap: () {
            pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.bounceInOut);
            if (currentPage == 3) {
              navigation(context, const LoginPage(), true);
            }
            setState(() {});
          },
        ),
      ),
      SizedBox(height: height(context) * 0.1)
    ]),
          ),
        );
  }
}
