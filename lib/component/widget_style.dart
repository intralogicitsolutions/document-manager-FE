import 'package:flutter/material.dart';

const noBorder =  InputDecoration(
  contentPadding: EdgeInsets.zero,
  border: OutlineInputBorder(
    borderSide: BorderSide.none, // No underline
  ),
);


InputDecoration decorationWithHintandPreIcon(
    {required String hint, required TextStyle hintStyle, required Widget prefixIcon,  Widget? suffixIcon}){
  return InputDecoration(
    hintText: hint,
    hintStyle: hintStyle,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: EdgeInsets.zero,
    border: const OutlineInputBorder(
      borderSide: BorderSide.none, // No underline
    ),
  );
}