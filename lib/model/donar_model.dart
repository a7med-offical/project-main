import 'dart:math';

import 'package:flutter/material.dart';

class Donar {
  String donarName;
  String donarId;
  String serialNum;
  String expiredDate;
  String createdDate;
  String bloodType;
  String moreDetails;

  Donar({
    required this.donarName,
    required this.donarId,
    required this.serialNum,
    required this.expiredDate,
    required this.bloodType,
    required this.moreDetails,
    required this.createdDate,
  }) {
    serialNum = generateSerialNumber();
    expiredDate = formatDate(add35DaysToDateFromNow());
  }

  String generateSerialNumber() {
    Random random = Random();
    int num = random.nextInt(9000) + 1000; // Generate a random 4-digit number
    return num.toString();
  }

  String formatDate(DateTime date) {
    return "${date.year}-${_formatTwoDigits(date.month)}-${_formatTwoDigits(date.day)}";
  }

  String _formatTwoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  DateTime add35DaysToDateFromNow() {
    DateTime now = DateTime.now();
    return now.add(Duration(days: 35));
  }

  static TextEditingController nameController = TextEditingController();
  static TextEditingController idController = TextEditingController();
  static TextEditingController expiredDateController = TextEditingController();
  static TextEditingController detailsController = TextEditingController();
  static TextEditingController serialNumber = TextEditingController();

  static void clearTextFields() {
    nameController.clear();
    serialNumber.clear();

    idController.clear();
    expiredDateController.clear();
    detailsController.clear();
  }
}
