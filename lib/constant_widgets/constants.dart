import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

const double kMinInteractiveDimension = 48.0;

/// The height of the toolbar component of the [AppBar].
const double kToolbarHeight = 56.0;

/// The height of the bottom navigation bar.
const double kBottomNavigationBarHeight = 56.0;

/// The height of a tab bar containing text.
const double kTextTabBarHeight = kMinInteractiveDimension;

/// The horizontal padding included by [Tab]s.
const EdgeInsets kTabLabelPadding = EdgeInsets.symmetric(horizontal: 16.0);

/// The padding added around material list items.
const EdgeInsets kMaterialListPadding = EdgeInsets.symmetric(vertical: 8.0);

const kSpaceBetween = MainAxisAlignment.spaceBetween;
const kStart = CrossAxisAlignment.start;

const Widget kHorizontalDivider = Divider(
  color: Colors.grey,
  height: 1,
);

const TextStyle kUserNameStyle = TextStyle(
  color: Colors.black87,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

const TextStyle kUserLocationStyle = TextStyle(
  color: Colors.black87,
  fontSize: 10,
  fontWeight: FontWeight.bold,
);

const TextStyle kPostTypeTextStyle =
    TextStyle(fontSize: 12, color: Colors.white);

const BoxDecoration kAdvertTypeBoxDecoration = BoxDecoration(
  color: Colors.deepOrange,
  borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(10), topLeft: Radius.circular(5)),
);
