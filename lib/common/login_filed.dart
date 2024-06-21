import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_user/constants.dart';

class LoginFiled extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  TextEditingController controller;
  String hintText;
  String? lableText;
  bool? isObsecure;
  bool? readOnly;
  String? prefixText;
  TextInputType? keyBord;
  IconButton? iconButton;
  Icon? prefixIcon;
  final String? Function(String?)? onPageChanged;
  final String? Function(String?)? validator;
  LoginFiled(
      {super.key,
      required this.controller,
      required this.hintText,
      this.inputFormatters,
      this.prefixText,
      this.prefixIcon,
      this.keyBord,
      this.isObsecure,
      this.iconButton,
      this.readOnly,
      this.validator,
      this.onPageChanged,
      this.lableText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        inputFormatters: inputFormatters,
        onChanged: onPageChanged,
        validator: validator,
        readOnly: readOnly ?? false,
        style: myFont500.copyWith(color: black),
        keyboardType: keyBord,
        obscureText: isObsecure ?? false,
        controller: controller,
        decoration: InputDecoration(
          
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: prefixIcon,
          suffixIcon: iconButton,
          labelStyle: myFont500.copyWith(color: grey),
          labelText: lableText,
          prefixText: prefixText,
          hintStyle: myFont500.copyWith(color: grey),
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 10),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
