import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/booking/service_detail.dart';
import 'package:wype_user/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeIn(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: height(context) * 0.05,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Image(
                image: const AssetImage('assets/images/logo.png'),
                height: height(context) * 0.1,
              ),
            ),
            15.height,
            TextFormField(
              cursorColor: lightGradient,
              decoration: InputDecoration(
                  hintStyle: GoogleFonts.readexPro(color: Colors.grey),
                  hintText: "Search for services...",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGradient),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: darkGradient),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.zero,
                  prefixIcon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: darkGradient,
                    size: 17,
                  )),
            ),
            20.height,
            Text(
              "Top Services",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightGradient),
            ),
            SizedBox(
              height: height(context) * 0.3,
              width: width(context),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: topServices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 25,
                  childAspectRatio: MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.2),
                ),
                itemBuilder: (BuildContext context, int index) {
                  var photo = AssetImage(topServices[index]);

                  return InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => const ServiceDetail().launch(context,
                        pageRouteAnimation: PageRouteAnimation.Fade),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: darkGradient),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: Center(
                            child: Image(image: photo),
                          ),
                        ),
                        5.height,
                        Text(
                          getAssetName(photo.assetName),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: lightGradient),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            15.height,
            Text(
              "Testimonials",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightGradient),
            ),
            20.height,
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: darkGradient),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "John Doe",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: darkGradient),
                          ),
                          Text(
                            "Bangalore",
                            style: GoogleFonts.readexPro(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: lightGradient),
                          ),
                        ],
                      ),
                      15.width,
                      RatingBar.builder(
                        itemSize: 25,
                        initialRating: 3.5,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: darkGradient,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                  10.height,
                  const Divider(
                    color: lightGray,
                  ),
                  10.height,
                  Text(
                    "Best Service Ever",
                    style: GoogleFonts.readexPro(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
