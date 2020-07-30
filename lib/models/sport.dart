import 'package:flutter/cupertino.dart';

enum SportType {
  Aerobic,
  BallSport,
  BodyBuilding,
}

enum SubSport {
  BasketBall,
  WeightLifting,
  CrossFit,
}

enum SportField {
  SPORT_TYPE,
  SUB_SPORT,
}

class Sport {
  SportType type;
  SubSport sport;

  Sport({
    @required this.type,
    @required this.sport,
  });
}
