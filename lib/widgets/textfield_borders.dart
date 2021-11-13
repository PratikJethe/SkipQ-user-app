import 'package:flutter/material.dart';

OutlineInputBorder formEnabledBorder = OutlineInputBorder();

OutlineInputBorder formErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red, width: 1),
);

OutlineInputBorder formBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black, width: 1),
);

OutlineInputBorder formPlainRoundedBorders = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent, width: 0),
  borderRadius: BorderRadius.circular(5.0),
);
