import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFFFAFAFA),
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(30, 0, 0, 0),
    secondary: Colors.black,
    surface: Colors.black,
    onPrimary: Colors.black,
  ),
);
