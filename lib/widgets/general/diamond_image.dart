import 'dart:math';

import 'package:flutter/material.dart';

class DiamondImage extends StatefulWidget {
  final ImageProvider imageProvider;
  final double size;
  final String heroTag;
  final void Function() callback;

  DiamondImage({this.imageProvider, this.size = 125, this.heroTag = "", this.callback});

  @override
  _DiamondImageState createState() => _DiamondImageState();
}

class _DiamondImageState extends State<DiamondImage> {
  Image getImage(double width, double height) {
    return Image(
      image: widget.imageProvider ?? AssetImage("assets/images/default_profile_image.png"),
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Widget getContent(double width, double height, double k) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 5),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: ClipRRect(
        child: Transform.rotate(
          angle: -pi / 4,
          child: Transform.scale(
              scale: k / 1.3,
              child: widget.heroTag != ""
                  ? Hero(tag: widget.heroTag, child: getImage(width, height))
                  : getImage(width, height)),
        ),
      ),
    );
  }

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
            child: widget.callback == null
                ? getContent(L, L, k)
                : GestureDetector(
                    onTap: widget.callback,
                    child: getContent(L, L, k),
                  )),
      ),
    );
  }
}
