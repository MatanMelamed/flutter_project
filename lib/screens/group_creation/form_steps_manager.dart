import 'dart:core';

import 'package:flutter/material.dart';

class FormStepsManager {
  Map<String, GlobalKey<FormFieldState>> _idToKey = Map();
  Map<String, bool> _idToErrorState = Map();
  Map<String, FocusNode> _idToFocusNode = Map();

  FormStepsManager addStepInfo(String id, {bool error = false}) {
    if (_idToKey.containsKey(id)) return null;

    _idToKey[id] = GlobalKey<FormFieldState>();
    _idToFocusNode[id] = FocusNode();
    _idToErrorState[id] = error;
    return this;
  }

  GlobalKey<FormFieldState> keyOf(String id) {
    return _idToKey[id];
  }

  bool errorStateOf(String id) {
    return _idToErrorState[id];
  }

  FocusNode focusNodeOf(String id) {
    return _idToFocusNode[id];
  }

  bool setErrorState(String id, bool value) => _idToErrorState[id] = value;

  List<String> identifiers() => _idToKey.keys.toList();

  void unFocusAll() {
    for (String id in this.identifiers())
      if (this.focusNodeOf(id).hasFocus) this.focusNodeOf(id).unfocus();
  }

  bool validateAndSave() {
    var finished = true;
    for (String id in this.identifiers()) {
      if (this.keyOf(id).currentState.validate()) {
        this.setErrorState(id, false);
        this.keyOf(id).currentState.save();
      } else {
        this.setErrorState(id, true);
        finished = false;
      }
    }
    return finished;
  }
}
