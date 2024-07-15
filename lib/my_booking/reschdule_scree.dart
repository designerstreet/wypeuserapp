// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RescheduleScreen extends StatefulWidget {
  Map<String, dynamic> booking;
  Map<String, dynamic> slot;
  RescheduleScreen({
    Key? key,
    required this.booking,
    required this.slot,
  }) : super(key: key);

  @override
  State<RescheduleScreen> createState() => _RescheduleScreenState();
}

class _RescheduleScreenState extends State<RescheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
