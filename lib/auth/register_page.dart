import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    TextEditingController number = TextEditingController();
    TextEditingController dob = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final ImagePicker picker = ImagePicker();
    File selectedImage = File("");
    int selectedValue = 1;
    // validateRadio(var value) {
    //   if (value == null) {
    //     return 'Please select an option';
    //   }
    //   return null;
    // }

    File? profileImage;
    Future uploadImg({required ImageSource source}) async {
      XFile? pickedFile = await picker.pickImage(source: source);
      selectedImage = File(pickedFile!.path);
    }

    void setDP() async {
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

    void datePicker(context) async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1947),
          lastDate: DateTime(2101));
      if (pickedDate != null) {
        log(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
        String formattedDate = DateFormat('yyyy-MM-dd').format(
            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
        log(formattedDate); //formatted date output using intl package =>  2022-07-04
        //You can format date as per your need

        dob.text = formattedDate; //set foratted date to TextField value.
      } else {
        log("Date is not selected");
      }
    }

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Your Details',
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
              selectedImage.path.isNotEmpty
                  ? Center(
                      child: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage: FileImage(selectedImage),
                          radius: 60,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 5,
                                bottom: 1,
                                child: Image.asset(
                                  editImg,
                                  width: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    )
                  : Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            setDP();
                          });
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              //Get image from data here
                              const NetworkImage('url'),
                          // FileImage(
                          //     registerController.selectedImage.value),
                          radius: 60,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 5,
                                bottom: 1,
                                child: Image.asset(
                                  editImg,
                                  width: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              LoginFiled(
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
              const SizedBox(
                height: 20,
              ),
              LoginFiled(
                readOnly: true,
                iconButton: IconButton(
                  onPressed: () async {
                    datePicker(context);
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
                controller: dob,
                hintText: 'Date of Birth',
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
              const SizedBox(
                height: 70,
              ),
              PrimaryButton(
                text: 'SIGN UP',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    toast('Register success !');

                    // Get.offAll(arguments: [], () {
                    //   return NavigationView(
                    //     name: registerController.name.text,
                    //     dob: registerController.dob.text,
                    //     phoneNum: registerController.number.text,
                    //     gender: registerController.selectedValue.value.toString(),
                    //   );
                    //   //  HomeView(
                    //   //   name: registerController.name.text,
                    //   //   dob: registerController.dob.text,
                    //   //   phoneNum: registerController.number.text,
                    //   //   gender:
                    //   //       registerController.selectedValue.value.toString(),
                    //   // );
                    // });
                  }
                },
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
