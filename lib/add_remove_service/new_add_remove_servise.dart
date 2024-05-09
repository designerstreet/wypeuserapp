// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:wype_user/booking/select_slot.dart';
import 'package:wype_user/common/add_remove_widget.dart';
import 'package:wype_user/common/wype_plus_container.dart';
import 'package:wype_user/common/wype_plus_row.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/model/promo_code_model.dart';

// class CustomService extends StatefulWidget {
//   String address;
//   var priceTotal;
//   int selectedVehicleIndex;
//   int? selectedPackageIndex;
//   String washCount;

//   Services? promoCode;
//   bool saveLocation;
//   Function()? onTap;
//   CustomService({
//     Key? key,
//     required this.address,
//     required this.priceTotal,
//     required this.selectedVehicleIndex,
//     required this.washCount,
//     this.promoCode,
//     required this.saveLocation,
//     this.selectedPackageIndex,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   State<CustomService> createState() => _CustomServiceState();
// }

// class _CustomServiceState extends State<CustomService> {
//   int counter = 1;
//   void add() {
//     setState(() {
//       counter++;
//     });
//   }

//   void dec() {
//     setState(() {
//       counter--;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Custom Service',
//           style: myFont28_600,
//         ),
//       ),
//       body: FadeIn(
//           child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // if (counter != 0)
//             ListView.separated(
//               physics: const ScrollPhysics(),
//               shrinkWrap: true,
//               separatorBuilder: (context, index) => const SizedBox(
//                 height: 20,
//               ),
//               itemCount: 2,
//               itemBuilder: (context, index) {
//                 return PlusContainer(
//                     widget: Container(
//                       decoration: BoxDecoration(
//                           color: Utils().softBlue,
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(color: Utils().lightBlue)),
//                       child: Row(
//                         children: [
//                           IconButton(
//                               onPressed: () {
//                                 dec();
//                               },
//                               icon: FaIcon(
//                                 FontAwesomeIcons.minus,
//                                 size: 15,
//                                 color: Utils().blueDark,
//                               )),
//                           Text(
//                             counter.toString(),
//                             textAlign: TextAlign.center,
//                             style: myFont28_600.copyWith(
//                               color: Utils().lightBlue,
//                             ),
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 add();
//                               },
//                               icon: FaIcon(
//                                 FontAwesomeIcons.plus,
//                                 color: Utils().blueDark,
//                                 size: 15,
//                               )),
//                         ],
//                       ),
//                     ),
//                     img: 'assets/images/deepclean.png',
//                     washTitle: 'Interior Glass',
//                     priceTitle: '30 QAR',
//                     isSelected: false);
//               },
//             ),
//             const Spacer(),
//             wypePlusRow('Cart Total', widget.priceTotal, () {
//               SelectSlot(
//                       packageName: '',
//                       address: widget.address,
//                       price: widget.priceTotal,
//                       selectedPackageIndex: widget.selectedPackageIndex!,
//                       selectedVehicleIndex: widget.selectedVehicleIndex,
//                       saveLocation: false)
//                   .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
//             }, 'select slot')
//           ],
//         ),
//       )),
//     ));
//   }
// }
