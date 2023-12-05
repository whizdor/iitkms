import 'package:flutter/material.dart';
import 'package:iitkms/pallete.dart';

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Pallete.gradient1,
          Pallete.gradient2,
          Pallete.gradient3,
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ),
      borderRadius: BorderRadius.circular(30),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        fixedSize: const Size(395, 55),
      ),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
    ),
  );
}
