import 'package:demo/models/ad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showMessage({required String title, required String text, bool error = false}) {
  Get.back();
  Get.defaultDialog(
    barrierDismissible: false,
    title: title,
    cancel: TextButton(
      onPressed: () {
        Get.back();
        //showAdInterstitial();
      },
      child: Text('إغلاق'),
    ),
    middleTextStyle: TextStyle(color: error ? Colors.red : Colors.green),
    middleText: text,
  );
}
