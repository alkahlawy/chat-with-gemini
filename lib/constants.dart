import 'package:flutter/material.dart';
const kFamilyFont = 'Mulish';
const String kLogo = "assets/images/gemini.png";
const kApiKey = "YOUR_API_KEY";
const kSecondaryColor = Color(0xFF89d9f2);
const kPrimaryColor = LinearGradient(
  colors: [
    Color(0xFF4285F4), // Light blue (Google Blue)
    Color(0xFF6762C4), // Intermediate blue
    Color(0xFF8A56AC), // A slightly darker blue/purple
    Color(0xFF7E45A8), // a slightly more purple shade
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const kBackgroundColor = LinearGradient(
    colors: [
      Color(0xff222222),
      Color(0xff141414),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
);