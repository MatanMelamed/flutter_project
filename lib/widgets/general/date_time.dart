import 'package:flutter/material.dart';

Future<DateTime> selectDate(BuildContext context) async {
  final DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 3),
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(DateTime.now().year - 3));
  return date;
}