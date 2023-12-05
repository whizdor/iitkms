import 'package:flutter/material.dart';

class Pallete {
  static const Color backgroundColor = Color.fromRGBO(0, 0, 0, 1);
  static const Color gradient1 = Color.fromARGB(255, 0, 0, 0);
  static const Color gradient2 = Color.fromRGBO(0, 0, 0, 1);
  static const Color gradient3 = Color.fromRGBO(0, 0, 0, 1);
  static const Color borderColor = Color(0xFF343343);
  static const Color whiteColor = Colors.white;
}

var textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white),
  contentPadding: const EdgeInsets.all(27),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Pallete.borderColor,
      width: 3,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Pallete.gradient2,
      width: 3,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  // focusedBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  // ),
  // errorBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xFFee7b64), width: 2),
  // ),
);
