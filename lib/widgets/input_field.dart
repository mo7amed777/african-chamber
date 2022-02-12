import 'package:demo/constants.dart';
import 'package:flutter/material.dart';

Card inputField(
    {required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required Function validate,
    required IconData icon,
    bool obsecured = false}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
    child: TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      validator: (value) => validate(value),
      obscureText: obsecured,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        errorStyle: TextStyle(backgroundColor: SECONDARYCOLOR),
        border: InputBorder.none,
        hintText: label,
        suffixIcon: Icon(
          icon,
        ),
      ),
    ),
  );
}
