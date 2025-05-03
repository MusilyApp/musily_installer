import 'package:flutter/material.dart';

extension MusilyBuildContext on BuildContext {
  ThemeData get themeData {
    return Theme.of(this);
  }

  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
