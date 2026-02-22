

import 'package:flutter/material.dart';
import 'package:website/theme/text_theme.dart';

final AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: Colors.deepPurple,
  elevation: 0,
);


ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: appBarTheme,
  textTheme: AppTextTheme.theme,
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);