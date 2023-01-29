import 'package:flutter/material.dart';

const _buttonColor = Color(0XFFDB5B42);

final theme = ThemeData(
  primaryColor: const Color(0XFFD20101),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  indicatorColor: _buttonColor,
);

const _darkPrimaryColor = Color(0xFF612222);
final darkTheme = ThemeData(
  primaryColor: _darkPrimaryColor,
  indicatorColor: _buttonColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  checkboxTheme: CheckboxThemeData(
    checkColor: MaterialStateProperty.all(_buttonColor),
    fillColor: MaterialStateProperty.all(_darkPrimaryColor),
  ),
  brightness: Brightness.dark,
);
