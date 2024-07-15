import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:wype_user/common/add_remove_widget.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_model.dart';
import 'package:wype_user/provider/language.dart';

class AddRemoveService extends StatefulWidget {
  LatLng coordinates;
  String address;
  int selectedVehicleIndex;
  int selectedPackageIndex;
  int washCount;
  num price;
  Services? promoCode;
  bool saveLocation;
  AddRemoveService(
      {super.key,
      required this.coordinates,
      required this.address,
      required this.selectedPackageIndex,
      required this.selectedVehicleIndex,
      required this.washCount,
      required this.price,
      required this.saveLocation,
      this.promoCode});

  @override
  State<AddRemoveService> createState() => _AddRemoveServiceState();
}

class _AddRemoveServiceState extends State<AddRemoveService> {
  @override
  void initState() {
    super.initState();
  }

  List<int> addPriceIndex = [];
  List<int> removePriceIndex = [];

  List<String> addedService = [];
  List<String> removedService = [];
  TextEditingController commentCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      backgroundColor: white,
      body: FadeIn(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
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
                Expanded(
                  child: Text(
                    subscriptionPackage[widget.selectedPackageIndex].name ??
                        "N/A",
                    style: GoogleFonts.readexPro(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: lightGradient),
                  ),
                ),
              ],
            ),
            40.height,
            Text(
              userLang.isAr ? "userLang" : "Add Services",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGradient),
            ),
            20.height,
            subscriptionPackage[widget.selectedPackageIndex].addServices !=
                        null &&
                    (subscriptionPackage[widget.selectedPackageIndex]
                            .addServices
                            ?.isEmpty ??
                        false)
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      userLang.isAr
                          ? "لم يتم العثور على أي حجوزات"
                          : "No Services at the moment",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.readexPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: subscriptionPackage[widget.selectedPackageIndex]
                            .addServices!
                            .length ??
                        0,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (addPriceIndex.contains(index)) {
                              addedService.remove(subscriptionPackage[
                                          widget.selectedPackageIndex]
                                      .addServices?[index]
                                      .name ??
                                  "");
                              widget.price = widget.price -
                                  (subscriptionPackage[
                                              widget.selectedPackageIndex]
                                          .addServices?[index]
                                          .price ??
                                      0);
                              addPriceIndex.remove(index);
                            } else {
                              addedService.add(subscriptionPackage[
                                          widget.selectedPackageIndex]
                                      .addServices?[index]
                                      .name ??
                                  "");
                              widget.price = widget.price +
                                  (subscriptionPackage[
                                              widget.selectedPackageIndex]
                                          .addServices?[index]
                                          .price ??
                                      0);
                              addPriceIndex.add(index);
                            }
                            setState(() {});
                          },
                          child: AddRemoveWidget(
                            title:
                                subscriptionPackage[widget.selectedPackageIndex]
                                        .addServices?[index]
                                        .name ??
                                    "N/A",
                            subtitle:
                                subscriptionPackage[widget.selectedPackageIndex]
                                        .addServices?[index]
                                        .subtitle ??
                                    "N/A",
                            isOnlyRemove: false,
                            isSelected: addPriceIndex.contains(index),
                            price:
                                subscriptionPackage[widget.selectedPackageIndex]
                                    .addServices?[index]
                                    .price
                                    .toString(),
                          ),
                        ),
                      );
                    }),
            20.height,
            Text(
              userLang.isAr ? "إزالة الخدمات" : "Remove Services",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGradient),
            ),
            20.height,
            subscriptionPackage[widget.selectedPackageIndex].removeServices !=
                        null &&
                    (subscriptionPackage[widget.selectedPackageIndex]
                            .removeServices
                            ?.isEmpty ??
                        false)
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      userLang.isAr
                          ? "لم يتم العثور على أي حجوزات"
                          : "No Services at the moment",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.readexPro(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: subscriptionPackage[widget.selectedPackageIndex]
                            .removeServices
                            ?.length ??
                        0,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 0),
                        child: InkWell(
                          onTap: () {},
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (removePriceIndex.contains(index)) {
                                removePriceIndex.remove(index);
                                removedService.remove(subscriptionPackage[
                                            widget.selectedPackageIndex]
                                        .removeServices?[index]
                                        .name ??
                                    "");
                                widget.price = ((widget.price) +
                                    (subscriptionPackage[
                                                widget.selectedPackageIndex]
                                            .removeServices?[index]
                                            .price ??
                                        0));
                              } else {
                                removePriceIndex.add(index);
                                removedService.add(subscriptionPackage[
                                            widget.selectedPackageIndex]
                                        .removeServices?[index]
                                        .name ??
                                    "");
                                widget.price = ((widget.price) -
                                    (subscriptionPackage[
                                                widget.selectedPackageIndex]
                                            .removeServices?[index]
                                            .price ??
                                        0));
                              }
                              setState(() {});
                            },
                            child: AddRemoveWidget(
                              title: subscriptionPackage[
                                          widget.selectedPackageIndex]
                                      .removeServices?[index]
                                      .name ??
                                  "N/A",
                              subtitle: subscriptionPackage[
                                          widget.selectedPackageIndex]
                                      .removeServices?[index]
                                      .subtitle ??
                                  "N/A",
                              isOnlyRemove: true,
                              isSelected: removePriceIndex.contains(index),
                              price: subscriptionPackage[
                                          widget.selectedPackageIndex]
                                      .removeServices?[index]
                                      .price
                                      .toString() ??
                                  "N/A",
                            ),
                          ),
                        ),
                      );
                    }),
            20.height,
            Text(
              userLang.isAr ? "أضف تعليقات" : "Add Comments",
              style: GoogleFonts.readexPro(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkGradient),
            ),
            20.height,
            Container(
              height: height(context) * 0.1,
              width: width(context),
              decoration: BoxDecoration(
                  border: Border.all(color: darkGradient),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: commentCont,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: userLang.isAr
                        ? "أضف بعض التعليقات"
                        : "Add some comments",
                    contentPadding: const EdgeInsets.all(10)),
                maxLength: null,
                maxLines: null,
                expands: true,
              ),
            ),
            40.height,
            Align(
              alignment: Alignment.center,
              child: PrimaryButton(
                  text: "${userLang.isAr ? "يدفع" : "Pay"} ${widget.price} QR",
                  onTap: () => SelectSlot(
                        saveLocation: widget.saveLocation,
                        comments: commentCont.text,
                        promoCode: widget.promoCode,
                        washCount: widget.washCount,
                        price: widget.price,
                        coordinates: widget.coordinates,
                        address: widget.address,
                        selectedVehicleIndex: widget.selectedVehicleIndex,
                        selectedPackageIndex: widget.selectedPackageIndex,
                        addService: addedService,
                        removeService: removedService,
                      ).launch(context,
                          pageRouteAnimation: PageRouteAnimation.Fade)),
            ),
          ],
        ),
      ),
    );
  }
}
