import 'package:flutter/material.dart';

// Primary color: #3CB145 (Green)
const Color primaryColor = Color(0xFF3CB145);
const Color secondaryColor = Colors.white;
const Color textColor = Colors.black87;
const Color borderColor = Colors.black26;

// Text Styles
const TextStyle headingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: textColor,
);

const TextStyle labelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: textColor,
);

const TextStyle inputStyle = TextStyle(
  fontSize: 16,
  color: textColor,
);

// Box Decorations for Input Fields
final BoxDecoration inputDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  border: Border.all(color: borderColor),
);

// Input Decoration
InputDecoration inputDecorationin(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: inputStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: secondaryColor,
  );
}

// Button Style
final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white, // Text color
  backgroundColor: primaryColor, // Green button
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

// AppBar Theme
final AppBarTheme appBarTheme = AppBarTheme(
  backgroundColor: primaryColor,
  elevation: 0,
  titleTextStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  ),
);

const loadingIndicatorStyle = CircularProgressIndicator(
  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
);
