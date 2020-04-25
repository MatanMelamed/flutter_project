import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class DiamondImage extends StatefulWidget {

  File previewImage;
  double size;

  DiamondImage({this.previewImage,this.size = 125});

  @override
  _DiamondImageState createState() => _DiamondImageState();
}

class _DiamondImageState extends State<DiamondImage> {

  @override
  Widget build(BuildContext context) {

    double L = widget.size; // image side length
    double R = 3; // rounding radius
    double k = sqrt(2) - R / L * 2 * (sqrt(2) - 1); // a little bit of geometry

    return Transform.rotate(
      angle: pi / 4,
      child: Transform.scale(
        scale: 1 / k,
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87,width: 5),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),

            child: Transform.rotate(
              angle: - pi / 4,
              child: Transform.scale(
                scale: k/1.3,
                child: Image(
                  image: widget.previewImage == null ? AssetImage("assets/images/default_profile_img.png") : FileImage(widget.previewImage),
                  width: L,
                  height: L,
                  fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ),
        ),
      );;
  }
}
