// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/common/set_dp.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';

import '../provider/image_provier.dart';

class UpdateProfile extends StatefulWidget {
  String name;
  String number;

  UpdateProfile({
    Key? key,
    required this.name,
    required this.number,
  }) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final formKey = GlobalKey<FormState>();

  int? selectedValue;
  bool isLoading = false;
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);
    var setImage = Provider.of<SetImageProvider>(context, listen: true);
    TextEditingController name = TextEditingController(text: widget.name);
    TextEditingController number = TextEditingController(text: widget.number);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: myFont28_600.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // selectedImage.path.isNotEmpty
              //     ? Center(
              //         child: GestureDetector(
              //           child: CircleAvatar(
              //             backgroundImage: FileImage(selectedImage),
              //             radius: 60,
              //             child: Stack(
              //               children: [
              //                 Positioned(
              //                   right: 5,
              //                   bottom: 1,
              //                   child: Image.asset(
              //                     editImg,
              //                     width: 32,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           onTap: () {
              //             updateProfile(context);
              //           },
              //         ),
              //       )
              //     : Center(
              //         child: GestureDetector(
              //           onTap: () {
              //             setState(() {
              //               updateProfile(context);
              //               // setDP(context);
              //             });
              //           },
              //           child: CircleAvatar(
              //             backgroundImage:
              //                 //Get image from data here
              //                 const NetworkImage('url'),
              //             // FileImage(
              //             //     registerController.selectedImage.value),
              //             radius: 60,
              //             child: Stack(
              //               children: [
              //                 Positioned(
              //                   right: 5,
              //                   bottom: 1,
              //                   child: Image.asset(
              //                     editImg,
              //                     width: 32,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              const SizedBox(
                height: 20,
              ),
              LoginFiled(
                keyBord: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter name';
                  }
                  return null;
                },
                controller: name,
                hintText: 'Name',
                isObsecure: false,
              ),
              const SizedBox(
                height: 20,
              ),
              LoginFiled(
                keyBord: TextInputType.number,
                controller: number,
                hintText: 'Mobile',
                isObsecure: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter number';
                  }
                  return null;
                },
              ),
              20.height,
              LoginFiled(
                readOnly: true,
                iconButton: IconButton(
                  onPressed: () async {
                    datePicker(context);
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
                controller: dob,
                hintText: userData!.dob.toString(),
                isObsecure: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Gender',
                style: myFont28_600.copyWith(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue:
                        selectedValue, // State variable for selected value
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Male',
                      style: myFont500.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Radio(
                    value: 2,
                    groupValue:
                        selectedValue, // Same groupValue for both radios
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Female',
                      style: myFont500.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              30.height,
              PrimaryButton(
                text: 'UPDATE PROFILE',
                onTap: () async {
                  try {
                    await firebaseService.updateProfile(userData!.id.toString(),
                        name.text, number.text, dob.text);
                    log('update success !');
                  } catch (e) {
                    toast('error in update profile');
                  }
                  // if (formKey.currentState!.validate()) {
                  //   toast('Register success !');
                  //   if (number.text.isEmptyOrNull ||
                  //       name.text.isEmptyOrNull ||
                  //       dob.text.isEmptyOrNull) {
                  //     toast(userLang.isAr
                  //         ? "أدخل بيانات اعتماد صالحة"
                  //         : "Enter valid credentials");
                  //   } else {
                  //     hideKeyboard(context);
                  //     try {
                  //       setState(() {
                  //         isLoading = true;
                  //       });

                  //     } catch (e) {
                  //       Get.snackbar(
                  //           userLang.isAr
                  //               ? "بيانات الاعتماد غير صالحة"
                  //               : "Invalid credentials",
                  //           userLang.isAr
                  //               ? "بيانات الاعتماد غير صالحة"
                  //               : "Invalid credentials");
                  //       setState(() {
                  //         isLoading = false;
                  //       });
                  //     }
                  //   }
                  //   // Get.offAll(arguments: [], () {
                  //   //   return NavigationView(
                  //   //     name: registerController.name.text,
                  //   //     dob: registerController.dob.text,
                  //   //     phoneNum: registerController.number.text,
                  //   //     gender: registerController.selectedValue.value.toString(),
                  //   //   );
                  //   //   //  HomeView(
                  //   //   //   name: registerController.name.text,
                  //   //   //   dob: registerController.dob.text,
                  //   //   //   phoneNum: registerController.number.text,
                  //   //   //   gender:
                  //   //   //       registerController.selectedValue.value.toString(),
                  //   //   // );
                  //   // });
                  // }
                },
              ),
              30.height
            ]),
          ),
        ),
      ),
    );
  }

  void updateProfile(context) async {
    final ImagePicker picker = ImagePicker();
    File selectedImage = File("");
    Future uploadImg({required ImageSource source}) async {
      XFile? pickedFile = await picker.pickImage(source: source);
      selectedImage = File(pickedFile!.path);
    }

    File? profileImage;
    void setDP(context) async {
      await showDialog(
          barrierColor: const Color.fromARGB(187, 0, 0, 0),
          context: context,
          builder: (context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              backgroundColor: Utils().lightBlue,
              title: const Center(
                child: Text(
                  "Select one",
                ),
              ),
              content: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              uploadImg(source: ImageSource.gallery);
                            },
                            child: const Icon(Icons.image)),
                        const SizedBox(
                          height: 0.01,
                        ),
                        const Text(
                          "Gallery",
                        ),
                      ],
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 0.01,
                        ),
                        Text(
                          " OR ",
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              uploadImg(source: ImageSource.camera);
                            },
                            child: const Icon(Icons.camera)),
                        const SizedBox(),
                        const Text(
                          "Camera",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.all(10),
          elevation: 1,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined)),
              ),
              const Text('Delete Photo'),
              const Divider(),
              InkWell(
                  onTap: () {
                    setDP(context);
                  },
                  child: const Text('Change Photo')),
              const Divider(),
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Cancel')),
            ],
          ),
        );
      },
    );
  }
}
