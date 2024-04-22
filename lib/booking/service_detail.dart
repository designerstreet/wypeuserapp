import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '../constants.dart';

class ServiceDetail extends StatefulWidget {
  const ServiceDetail({super.key});

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: FadeIn(
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(
              height: height(context) * 0.06,
            ),
            Text(
              "Car Wash",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightGradient),
            ),
            30.height,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.grey.shade300),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Car Wash",
                            style: GoogleFonts.readexPro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkGradient),
                          ),
                          Text(
                            "AD 500",
                            style: GoogleFonts.readexPro(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: darkGradient),
                          ),
                        ],
                      )),
                  20.height,
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• Car Washing",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: darkGradient),
                          ),
                          10.height,
                          Text(
                            "• Wheel Balancing",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: darkGradient),
                          ),
                           10.height,
                          Text(
                            "• Break Fluids",
                            style: GoogleFonts.readexPro(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: darkGradient),
                          ),
                        ],
                      )),
                      20.height,
                ],
              ),
            ),
            30.height,
             Text(
              "Description",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightGradient),
            ),
            10.height,
             Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam molestie consectetur turpis, sed iaculis leo dignissim at. Etiam sollicitudin aliquet libero ac posuere. Phasellus feugiat a ex eget vehicula. In sed dolor dolor. Proin varius pharetra accumsan. Nulla convallis sed lectus in ultricies. Donec a faucibus augue.",
              style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            20.height,
         
          ],
        ),
      ),
    );
  }
}
