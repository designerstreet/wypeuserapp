import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/auth/login_page.dart';
import 'package:wype_user/common/car_container.dart';
import 'package:wype_user/model/promo_code_old.dart';
import 'package:wype_user/model/user_model.dart';
import 'package:wype_user/provider/language.dart';
import '../common/custom_dropdown.dart';
import '../common/primary_button.dart';
import '../constants.dart';
import 'subscriptions.dart';
import '../services/firebase_services.dart';

class AddVehiclePage extends StatefulWidget {
  bool isFromHome;
  LatLng? coordinates;
  String? address;
  Services? promoCode;
  bool saveLocation;
  AddVehiclePage(
      {super.key,
      required this.isFromHome,
      required this.saveLocation,
      this.coordinates,
      this.address,
      this.promoCode});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  String? selectedModel;
  String? selectedCompany;
  int? selectedVehicleIndex;

  FirebaseService firebaseService = FirebaseService();
  TextEditingController plateCont = TextEditingController();
  bool isAdding = false;

  addVehicleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var userLang = Provider.of<UserLang>(context, listen: true);

          return StatefulBuilder(builder: (context, dialogState) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical:
                      (WidgetsBinding.instance.window.viewInsets.bottom > 0.0)
                          ? 0
                          : height(context) * 0.2),
              child: Dialog(
                elevation: 2,
                backgroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          userLang.isAr ? "اختر مركبة" : "Select Vehicle",
                          style: GoogleFonts.readexPro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: darkGradient),
                        ),
                      ),
                      20.height,
                      CustomDropDown(
                          hintText: userLang.isAr
                              ? "اختر شركة المركبات"
                              : "Select Vehicle Company",
                          selectedValue: selectedCompany,
                          maxLimit: carBrands,
                          isNotification: true,
                          onChanged: (val) {
                            selectedCompany = val!;
                            dialogState(() {});
                          }),
                      20.height,
                      CustomDropDown(
                          hintText: userLang.isAr
                              ? "حدد طراز السيارة"
                              : "Select Vehicle Model",
                          selectedValue: selectedModel,
                          maxLimit: carModels[selectedCompany] ?? [],
                          isNotification: true,
                          onChanged: (val) {
                            selectedModel = val!;
                            dialogState(() {});
                          }),
                      10.height,
                      AppTextField(
                        textStyle: GoogleFonts.readexPro(),
                        textFieldType: TextFieldType.NAME,
                        controller: plateCont,
                        decoration: inputDecoration(context,
                            labelText: userLang.isAr
                                ? "لوحة رقم-اختياري"
                                : "Plate No- Optional"),
                      ),
                      30.height,
                      Align(
                        alignment: Alignment.center,
                        child: PrimaryButton(
                          text: isAdding
                              ? loaderText
                              : userLang.isAr
                                  ? "يضيف"
                                  : "Add",
                          onTap: () async {
                            if (selectedModel == null ||
                                selectedCompany == null) {
                              toast(userLang.isAr
                                  ? "الرجاء إضافة الشركة والموديل"
                                  : "Please add company and model");
                            } else {
                              isAdding = true;
                              dialogState(() {});
                              Vehicle vehicle = Vehicle(
                                  model: selectedModel,
                                  company: selectedCompany,
                                  numberPlate: plateCont.text.isEmpty
                                      ? userLang.isAr
                                          ? "لا يوجد"
                                          : "N/A"
                                      : plateCont.text);
                              userData?.vehicle?.add(vehicle);
                              await firebaseService.addVehicle(vehicle);
                              selectedCompany = null;
                              selectedModel = null;
                              plateCont.clear();
                              isAdding = false;
                              dialogState(() {});
                              setState(() {});
                              popNav(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height(context) * 0.05,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isFromHome
                    ? Text(
                        userLang.isAr ? "مركبات" : "Vehicles",
                        style: GoogleFonts.readexPro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkGradient),
                      )
                    : InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => popNav(context),
                        child: Icon(
                          isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                          // size: 30,
                        ),
                      ),
                widget.isFromHome
                    ? Container()
                    : Text(
                        widget.isFromHome
                            ? userLang.isAr
                                ? "مركبات"
                                : "Vehicles"
                            : userLang.isAr
                                ? "إضافة المركبات"
                                : "  Select Your Vehicle",
                        style: myFont28_600),
                // InkWell(
                //   onTap: () => addVehicleDialog(),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: darkGradient,
                //     ),
                //     padding: const EdgeInsets.all(5),
                //     child: const Center(
                //       child: Icon(
                //         Icons.add,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            (userData?.vehicle?.isEmpty ?? true)
                ? Expanded(
                    child: Center(
                      child: Text(
                        userLang.isAr
                            ? "لم يتم العثور على مركبات"
                            : "No Vehicles found",
                        style: GoogleFonts.readexPro(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkGradient),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userData?.vehicle?.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              selectedVehicleIndex = index;
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: CarContainer(
                                deleteCar: () {
                                  userData?.vehicle?.removeAt(index);
                                  setState(() {});
                                  firebaseService
                                      .deleteVehicle(userData?.vehicle);
                                },
                                isFromHome: widget.isFromHome,
                                name:
                                    userData?.vehicle?[index].company ?? "N/A",
                                model: userData?.vehicle?[index].model ?? "N/A",
                                registration:
                                    userData?.vehicle?[index].numberPlate ??
                                        "N/A",
                                isSelected: widget.isFromHome
                                    ? false
                                    : selectedVehicleIndex == index,
                              ),
                            ),
                          );
                        }),
                  ),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(30),
              color: Utils().skyBlue,
              strokeWidth: 1,
              dashPattern: const [
                5,
                5,
              ],
              child: GestureDetector(
                onTap: () {
                  addVehicleDialog();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromRGBO(225, 242, 242, 1)),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Utils().lightBlue,
                      ),
                      Text("add new vehicle".toUpperCase(),
                          style:
                              myFont28_600.copyWith(color: Utils().lightBlue)),
                    ],
                  ),
                ),
              ),
            ),
            20.height,
            widget.isFromHome
                ? Container()
                : Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: PrimaryButton(
                        text: userLang.isAr ? "التالي" : "Next",
                        onTap: () {
                          if (selectedVehicleIndex == null) {
                            toast(userLang.isAr
                                ? "الرجاء اختيار السيارة"
                                : "Please select vehicle");
                          } else {
                            SubscriptionPage(
                              carName: userData?.vehicle?[selectedVehicleIndex!]
                                      .company ??
                                  "N/A",
                              carModel: userData
                                      ?.vehicle?[selectedVehicleIndex!].model ??
                                  "N/A",
                              saveLocation: widget.saveLocation,
                              promoCode: widget.promoCode,
                              coordinates: widget.coordinates!,
                              address: widget.address!,
                              selectedVehicleIndex: selectedVehicleIndex!,
                            ).launch(context,
                                pageRouteAnimation: PageRouteAnimation.Fade);
                            log("user contact ${userData?.vehicle?[selectedVehicleIndex!].company ?? "N/A"}");
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
