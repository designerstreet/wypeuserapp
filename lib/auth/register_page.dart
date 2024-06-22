import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:wype_user/common/login_filed.dart';
import 'package:wype_user/common/primary_button.dart';
import 'package:wype_user/common/set_dp.dart';
import 'package:wype_user/constants.dart';
import 'package:wype_user/provider/language.dart';
import 'package:wype_user/services/firebase_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedValue = 1;
  File? selected;

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  bool isLoading = false;
  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    name.dispose();
    number.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userLang = Provider.of<UserLang>(context, listen: true);

    FirebaseService firebaseService = FirebaseService();

    // validateRadio(var value) {
    //   if (value == null) {
    //     return 'Please select an option';
    //   }
    //   return null;
    // }

    return Scaffold(
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
                            setDP(context);
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
              IntlPhoneField(
                controller: number,
                showCountryFlag: true,
                flagsButtonPadding: const EdgeInsets.all(5),
                showDropdownIcon: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 10),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                initialCountryCode: 'QA',
                countries: const [
                  Country(
                    name: 'Qatar',
                    flag: '🇶🇦',
                    code: 'QA',
                    dialCode: '974',
                    nameTranslations: {
                      'en': 'Qatar',
                    },
                    minLength: 8,
                    maxLength: 8,
                  ),
                  Country(
                    name: 'India',
                    flag: '🇮🇳',
                    code: 'IN',
                    dialCode: '91',
                    nameTranslations: {
                      'en': 'India',
                      // Add other language translations if necessary
                    },
                    minLength: 10,
                    maxLength: 10,
                  )
                ],
                onChanged: (phone) {
                  log(phone.completeNumber);
                },
              ),
              20.height,
              LoginFiled(
                keyBord: TextInputType.visiblePassword,
                controller: password,
                hintText: 'Password',
                isObsecure: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter password';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  const Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Radio(
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                  ),
                  const Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              30.height,
              PrimaryButton(
                text: 'SIGN UP',
                isLoading: isLoading,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await firebaseService.login(
                          context,
                          true,
                          name.text,
                          number.text,
                          selectedValue.toString() == '1' ? 'Male' : 'Female',
                          password.text,
                          selectedImage.toString(),
                          dob.text.toString(),
                          userLang.isAr ? "ar" : "en");

                      setState(() {
                        isLoading = false;
                      });
                      Get.snackbar('Register', 'User Registration is Success!');
                    } catch (e) {
                      toast(e.toString());
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
              ),
              30.height
            ]),
          ),
        ),
      ),
    );
  }
}
