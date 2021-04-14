import 'package:flutter/material.dart';

class BottomBarItem {
  /// An icon to display.
  final Widget icon;

  /// Text to display, ie `Home`
  final Widget title;

  /// A primary color to use for this tab.
  final Color selectedColor;

  /// The color to display when this tab is not selected.
  final Color unselectedColor;

  //The screen will display the screen that is required to show on click of the Bottom Bar Item
  final Widget screen;

  BottomBarItem({
    @required this.icon,
    @required this.title,
    @required this.screen,
    this.selectedColor,
    this.unselectedColor,
  })  : assert(icon != null, "Every Bottom Bar Item requires an icon."),
        assert(title != null, "Every Bottom Bar Item requires a title."),
        assert(screen != null, "Every Bottom Bar Item requires a screen");
}