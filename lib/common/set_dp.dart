import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wype_user/constants.dart';

// final ImagePicker picker = ImagePicker();
// File selectedImage = File("");
// Future uploadImg({required ImageSource source}) async {
//   XFile? pickedFile = await picker.pickImage(source: source);
//   selectedImage = File(pickedFile!.path);
// }

// File? profileImage;
// void setDP(context) async {
//   await showDialog(
//       barrierColor: const Color.fromARGB(187, 0, 0, 0),
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           insetPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//           backgroundColor: Utils().lightBlue,
//           title: const Center(
//             child: Text(
//               "Select one",
//             ),
//           ),
//           content: SizedBox(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           uploadImg(source: ImageSource.gallery);
//                         },
//                         child: const Icon(Icons.image)),
//                     const SizedBox(
//                       height: 0.01,
//                     ),
//                     const Text(
//                       "Gallery",
//                     ),
//                   ],
//                 ),
//                 const Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 0.01,
//                     ),
//                     Text(
//                       " OR ",
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           uploadImg(source: ImageSource.camera);
//                         },
//                         child: const Icon(Icons.camera)),
//                     const SizedBox(),
//                     const Text(
//                       "Camera",
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       });
// }
