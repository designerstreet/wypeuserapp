import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants.dart';

class CustomDropDown extends StatefulWidget {
  String? selectedValue;
  String? hintText;
  List<String> maxLimit;
  void Function(String?)? onChanged;
  bool? isNotification;
  bool? showSmall;
  CustomDropDown(
      {Key? key,
      this.selectedValue,
      required this.maxLimit,
      required this.onChanged,
      this.hintText,
      this.isNotification,
      this.showSmall})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  buttonStyle(context, bool showSmall) {
    return ButtonStyleData(
      height: height(context) * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: lightGray),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only( right: 14),
      elevation: 0,
    );
  }

  var iconStyle = IconStyleData(
    icon: const Icon(
      Icons.chevron_right,
      color: Colors.grey,
    ),
    iconEnabledColor: darkGradient,
    iconDisabledColor: darkGradient,
  );

  dropdownStyle(context) {
    return DropdownStyleData(
        maxHeight: height(context) * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: darkGradient),
          color: Colors.white,
        ),
        offset: const Offset(0, 0),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all<double>(6),
          thumbVisibility: MaterialStateProperty.all<bool>(true),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.hintText ?? widget.selectedValue!,
                style: GoogleFonts.readexPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.maxLimit
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: darkGradient,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: widget.selectedValue,
        onChanged: widget.onChanged,
        buttonStyleData: buttonStyle(context, (widget.showSmall ?? false)),
        iconStyleData: iconStyle,
        dropdownStyleData: dropdownStyle(context),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
