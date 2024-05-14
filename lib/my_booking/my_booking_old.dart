// import 'package:animate_do/animate_do.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';
// import 'package:wype_user/common/booking_widget.dart';
// import 'package:wype_user/model/booking.dart';
// import 'package:wype_user/provider/language.dart';

// import '../constants.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   bool isOngoing = true;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<BookingModel> onGoingAndUpcomingBookings = [];
//   List<BookingModel> completedBookings = [];

//   bool isToday(DateTime date) {
//     DateTime now = DateTime.now();
//     return date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day;
//   }

//   bool isTomorrow(DateTime date) {
//     DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
//     return date.year == tomorrow.year &&
//         date.month == tomorrow.month &&
//         date.day == tomorrow.day;
//   }

//   void selectTime(BuildContext context) async {
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: SizedBox(
//             width: 200,
//             height: 200,
//             child: CupertinoPicker(
//               itemExtent: 33,
//               onSelectedItemChanged: (value) {},
//               children: List.generate(
//                 reSchedule.length,
//                 (index) => Text(reSchedule[index]),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var userLang = Provider.of<UserLang>(context, listen: true);

//     return Scaffold(
//       backgroundColor: whiteColor,
//       body: FadeIn(
//         child: Column(
//           // shrinkWrap: true,
//           // physics: AlwaysScrollableScrollPhysics(),
//           children: [
//             SizedBox(
//               height: height(context) * 0.07,
//             ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   userLang.isAr ? "الحجوزات" : "Bookings",
//                   style: GoogleFonts.readexPro(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: darkGradient),
//                 ),
//               ),
//             ),
//             25.height,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     onTap: () => setState(() {
//                       isOngoing = true;
//                     }),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           userLang.isAr ? "جاري التنفيذ" : "On Going",
//                           style: GoogleFonts.readexPro(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                         ),
//                         4.height,
//                         isOngoing
//                             ? Container(
//                                 height: 4,
//                                 width: width(context) * 0.28,
//                                 color: lightGradient,
//                               )
//                             : Container(
//                                 height: 4,
//                               ),
//                       ],
//                     ),
//                   ),
//                   30.width,
//                   InkWell(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     onTap: () => setState(() {
//                       isOngoing = false;
//                     }),
//                     child: Column(
//                       children: [
//                         Text(
//                           userLang.isAr ? "تاريخ" : "History",
//                           style: GoogleFonts.readexPro(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                         ),
//                         4.height,
//                         isOngoing
//                             ? Container(
//                                 height: 4,
//                               )
//                             : Container(
//                                 height: 4,
//                                 width: width(context) * 0.2,
//                                 color: lightGradient,
//                               ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             15.height,
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('bookings')
//                     .where('user_id', isEqualTo: userData?.id)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 20.0),
//                       child: Text(userLang.isAr
//                           ? "جلب الحجوزات الحالية..."
//                           : "Fetching current bookings..."),
//                     );
//                   }
//                   onGoingAndUpcomingBookings.clear();
//                   completedBookings.clear();

//                   for (var booking in snapshot.data!.docs) {
//                     var bookingData = booking.data() as Map<String, dynamic>;
//                     var bookingId = booking.id;
//                     var bookingInstance =
//                         BookingModel.fromMap(bookingId, bookingData);

//                     if (bookingInstance.bookingStatus == 'on_going' ||
//                         bookingInstance.bookingStatus == 'up_coming') {
//                       onGoingAndUpcomingBookings.add(bookingInstance);
//                     } else if (bookingInstance.bookingStatus == 'completed') {
//                       completedBookings.add(bookingInstance);
//                     }
//                   }

//                   if ((isOngoing && onGoingAndUpcomingBookings.isEmpty) ||
//                       (!isOngoing && completedBookings.isEmpty)) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 108.0),
//                       child: Text(
//                         userLang.isAr
//                             ? "لم يتم العثور على أي حجوزات"
//                             : "No Bookings found",
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.readexPro(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: darkGradient),
//                       ),
//                     );
//                   }

//                   return FadeIn(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 15.0),
//                       child: isOngoing
//                           ? ListView(
//                               padding: EdgeInsets.zero,
//                               physics: const BouncingScrollPhysics(),
//                               shrinkWrap: true,
//                               children: [
//                                 _buildCollapsibleContainer(
//                                     userLang.isAr ? "اليوم" : 'Today',
//                                     getTodayBooking(onGoingAndUpcomingBookings),
//                                     context),
//                                 _buildCollapsibleContainer(
//                                     userLang.isAr ? "غداً" : 'Tomorrow',
//                                     getTomorrowBooking(
//                                         onGoingAndUpcomingBookings),
//                                     context),
//                                 _buildCollapsibleContainer(
//                                     userLang.isAr ? "القادمة" : 'Upcoming',
//                                     getUpcomingBooking(
//                                         onGoingAndUpcomingBookings),
//                                     context),
//                               ],
//                             )
//                           : ListView(
//                               padding: EdgeInsets.zero,
//                               children: [
//                                 _buildCollapsibleContainer(
//                                     userLang.isAr ? "اليوم" : 'Today',
//                                     getTodayBooking(completedBookings),
//                                     context),
//                                 _buildCollapsibleContainer(
//                                     userLang.isAr ? "غداً" : 'Tomorrow',
//                                     getTomorrowBooking(completedBookings),
//                                     context),
//                                 _buildCollapsibleContainer(
//                                     userLang.isAr ? "القادمة" : 'Upcoming',
//                                     getUpcomingBooking(completedBookings),
//                                     context),
//                               ],
//                             ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<BookingModel> getTodayBooking(List<BookingModel> bookingList) {
//     return bookingList
//         .where((booking) => isToday(booking.washTimings.toDate()))
//         .toList();
//   }

//   List<BookingModel> getTomorrowBooking(List<BookingModel> bookingList) {
//     return bookingList
//         .where((booking) => isTomorrow(booking.washTimings.toDate()))
//         .toList();
//   }

//   List<BookingModel> getUpcomingBooking(List<BookingModel> bookingList) {
//     return bookingList
//         .where((booking) =>
//             !isToday(booking.washTimings.toDate()) &&
//             !isTomorrow(booking.washTimings.toDate()))
//         .toList();
//   }
// }

// Widget _buildCollapsibleContainer(
//     String title, List<BookingModel> bookings, BuildContext context) {
//   var userLang = Provider.of<UserLang>(context, listen: true);

//   return Theme(
//     data: ThemeData().copyWith(dividerColor: Colors.transparent),
//     child: ExpansionTile(
//       title: Text(
//         title,
//         style: GoogleFonts.readexPro(
//             fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient),
//       ),
//       children: [
//         if (bookings.isEmpty)
//           bookings.isEmpty
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 20.0, bottom: 40),
//                   child: Text(
//                     userLang.isAr
//                         ? "لم يتم العثور على أي حجوزات"
//                         : "No Bookings found",
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.readexPro(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w500,
//                         color: darkGradient),
//                   ),
//                 )
//               : Container()
//         else
//           for (var booking in bookings)
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: BookingWidget(bookingDetail: booking),
//             ),
//       ],
//     ),
//   );
// }

// // List<Widget> _buildClonedBookings(List<BookingModel> originalBooking) {
// //   return Padding(
// //       padding: const EdgeInsets.all(10),
// //       child: BookingWidget(bookingDetail: originalBooking),
// //     );
// // }
