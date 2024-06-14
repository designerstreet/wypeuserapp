import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/saved_location_model.dart';
import '../provider/language.dart';
import '../services/firebase_services.dart';

class SavedLocationPage extends StatefulWidget {
  const SavedLocationPage({super.key});

  @override
  State<SavedLocationPage> createState() => _SavedLocationPageState();
}

class _SavedLocationPageState extends State<SavedLocationPage> {
  FirebaseService firestoreService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      body: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: height(context) * 0.07,
              ),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => popNav(context),
                    child: Icon(
                      Icons.chevron_left,
                      size: 29,
                      color: lightGradient,
                    ),
                  ),
                  10.width,
                  Text(
                    userLang.isAr ? "الموقع المحفوظ" : "Saved Location",
                    style: GoogleFonts.readexPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: lightGradient),
                  ),
                ],
              ),
              30.height,
              Expanded(
                child: StreamBuilder<List<SavedLocation>>(
                    stream:
                        firestoreService.getSavedLocations(userData?.id ?? ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: darkGradient,
                            ),
                          ],
                        ); // Show loading indicator while waiting for data
                      }
                      if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show error message if data fetching fails
                      }

                      List<SavedLocation> savedLocations = snapshot.data ?? [];

                      if (savedLocations.isEmpty) {
                        return Text(
                          "No Saved locations found",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.readexPro(
                              fontSize: 16, color: Colors.black),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(left: 15),
                        itemCount: savedLocations.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var location = savedLocations[index];
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: ListTile(
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    firestoreService.deleteSavedLocation(
                                        userData?.id ?? "", location);
                                    toast("Deleted");
                                  },
                                ),
                                title: Text(
                                  location.address,
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  '${location.latitude}, ${location.longitude}',
                                  style: GoogleFonts.lato(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
