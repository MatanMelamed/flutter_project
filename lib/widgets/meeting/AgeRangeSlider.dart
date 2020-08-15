// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

class AgeRangeSliders extends StatefulWidget {
  final int currentStart;
  final int currentEnd;

  final void Function(int start, int end) callback;

  AgeRangeSliders({
    @required this.currentStart,
    @required this.currentEnd,
    this.callback,
  });

  @override
  _AgeRangeSlidersState createState() => _AgeRangeSlidersState();
}

class _AgeRangeSlidersState extends State<AgeRangeSliders> {
  double min = 15;
  double max = 80;
  RangeValues _discreteValues;

  @override
  void initState() {
    super.initState();
    _discreteValues = RangeValues(widget.currentStart.toDouble(), widget.currentEnd.toDouble());
  }

  void reload(){
    _discreteValues = RangeValues(widget.currentStart.toDouble(), widget.currentEnd.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    int div = (max - min).round();
    return Column(
      children: [
        Column(
          children: [
            Text(
              'Ages',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            RangeSlider(
              values: _discreteValues,
              min: min,
              max: max,
              divisions: div,
              labels: RangeLabels(
                _discreteValues.start.round().toString(),
                _discreteValues.end.round().toString(),
              ),
              onChanged: (values) {
                _discreteValues = values;
                setState(() {});
                if (widget.callback != null) {
                  widget.callback(_discreteValues.start.round(), _discreteValues.end.round());
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
