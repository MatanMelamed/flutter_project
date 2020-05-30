import 'package:flutter/material.dart';

Widget GetCicledImage() {
  return Container(
    width: 125,
    height: 125,
    child: GestureDetector(
      onTap: () {
        print('open image');
      },
    ),
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage("assets/images/default_profile_image.png"),
      ),
      borderRadius: BorderRadius.all(Radius.circular(75)),
      border: Border.all(color: Colors.black45, width: 2),
    ),
  );
}
Widget GetImageWidget() {

}
