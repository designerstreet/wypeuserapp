// import 'package:flutter/material.dart';
// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PackageNameModel {
//   final String id;
//   final String packageName;
//   final int washes;

//   PackageNameModel({
//     required this.id,
//     required this.packageName,
//     required this.washes,
//   });

//   factory PackageNameModel.fromMap(String id, Map<String, dynamic> data) {
//     return PackageNameModel(
//       id: id,
//       packageName: data['packageName'] ?? '',
//       washes: data['washes'] ?? 0,
//     );
//   }
// }

// Future<List<PackageNameModel>> fetchPackages() async {
//   var packageCollection = FirebaseFirestore.instance.collection('package');

//   QuerySnapshot querySnapshot = await packageCollection.get();
//   List<PackageNameModel> packages = querySnapshot.docs.map((doc) {
//     log(doc.data().toString());
//     return PackageNameModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
//   }).toList();

//   return packages;
// }

// class PackageSelectionWidget extends StatefulWidget {
//   final String cost;
//   final String address;
//   final int selectedVehicleIndex;

//   const PackageSelectionWidget({
//     Key? key,
//     required this.cost,
//     required this.address,
//     required this.selectedVehicleIndex,
//   }) : super(key: key);

//   @override
//   _PackageSelectionWidgetState createState() => _PackageSelectionWidgetState();
// }

// class _PackageSelectionWidgetState extends State<PackageSelectionWidget> {
//   int? selectedPackageIndex;
//   double? calculatedCost;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: FutureBuilder<List<PackageNameModel>>(
//             future: fetchPackages(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData && snapshot.data != null) {
//                 List<PackageNameModel> packages = snapshot.data!;
//                 return ListView.separated(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   separatorBuilder: (context, index) => const SizedBox(width: 12),
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemCount: packages.length,
//                   itemBuilder: (context, index) {
//                     PackageNameModel package = packages[index];
//                     double costForCurrentIndex =
//                         double.parse(widget.cost) * (index + 1) * 4;

//                     return InkWell(
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       onTap: () {
//                         log('Package Selected: ${package.packageName}');
//                         selectedPackageIndex = index;
//                         calculatedCost = costForCurrentIndex;

//                         setState(() {});
//                       },
//                       child: Container(
//                         height: 70,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 18),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 package.packageName,
//                                 style: const TextStyle(
//                                   fontSize: 25,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 '${package.washes} Washes',
//                                 style: const TextStyle(fontWeight: FontWeight.w500),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               } else if (snapshot.hasError) {
//                 return Text("Error: ${snapshot.error}");
//               }

//               // By default, show a loading spinner.
//               return const Center(child: CircularProgressIndicator());
//             },
//           ),
//         ),
       
//         wypePlusRow(
//           'Cart Total',
//           calculatedCost?.toStringAsFixed(2) ?? widget.cost,
//           () {
//             log(widget.cost);
//             double finalCost = calculatedCost ?? double.parse(widget.cost);
//             SelectSlot(
//               address: widget.address,
//               price: finalCost.toStringAsFixed(2),
//               selectedPackageIndex: selectedPackageIndex ?? -1,
//               selectedVehicleIndex: widget.selectedVehicleIndex,
//               saveLocation: true,
//             ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
//           },
//         ),
//       ],
//     );
//   }

//   Widget wypePlusRow(String title, String cost, VoidCallback onTap) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: const TextStyle(fontSize: 18)),
//           ElevatedButton(
//             onPressed: onTap,
//             child: Text(cost, style: const TextStyle(fontSize: 16)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SelectSlot {
//   final String address;
//   final String price;
//   final int selectedPackageIndex;
//   final int selectedVehicleIndex;
//   final bool saveLocation;

//   SelectSlot({
//     required this.address,
//     required this.price,
//     required this.selectedPackageIndex,
//     required this.selectedVehicleIndex,
//     required this.saveLocation,
//   });

//   void launch(BuildContext context, {required PageRouteAnimation pageRouteAnimation}) {
//     // Dummy implementation, replace this with actual navigation logic.
//     log('Navigating to SelectSlot with price: $price');
//   }
// }

// enum PageRouteAnimation {
//   Fade,
//   // Other animation styles can be added here.
// }

// void main() {
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Package Selection')),
//         body: PackageSelectionWidget(
//           cost: '100',
//           address: '123 Street',
//           selectedVehicleIndex: 1,
//         ),
//       ),
//     ),
//   );
// }
