import 'package:flutter/material.dart';

// Common Colors (kept as-is, but updated to match palettes)
const Color kButtonColor = Color(0xFF90DDD4);
const Color kTextFieldColor = Color(0xFF0A0035); // Dark navy for inputs
const Color kFontColor = Color(0xFFB23BFF);      // Violet subtitle
const Color kSubtitleColor = Color(0xFFB23BFF);  // Violet subtitle
const Color kCardColor = Color(0xFF3D1382);      // Purple card
const Color kLargeTextColor = Color(0xFFFFFFFF); // White for big text
const Color kPrimaryColor = Color(0xFF0A0035);   // Dark navy primary
const Color kSecondaryColor = Color(0xFF3D1382); // Purple secondary

// 🔹 Extra Colors (New)
const Color kNewTealColor = Color(0xFFB23BFF);       // Violet accent
const Color kDarkPrimaryBg = Color(0xFF0A0035);      // Dark navy bg
const Color kDarkCardBg = Color(0xFF3D1382);         // Purple card
const Color kDarkTextFieldBg = Color(0xFF0A0035);    // Navy text field
const Color kDarkSecondaryBg = Color(0xFF3D1382);    // Purple secondary bg
const Color kcontinueButtonColor = Color(0xFFFFC800);// Yellow CTA
const Color kLightGradientStart = Color(0xFF4B3FA3); // Dark purple gradient start
const Color kLightGradientEnd   = Color(0xFFAFA5FF); // Light purple gradient end
const Color kBlueIconColor      = Color(0xFF4A90E2);  
const Color kGreenIconColor     = Color(0xFF50C878);  
const Color kRedIconColor       = Color(0xFFFF6B6B);  
const Color kCyanIconColor      = Color(0xFF4ECDC4);  
const Color kDefaultIconColor   = Color(0xFFB23BFF); // Violet fallback

// Light Theme Palette (second image)
const Color kLightButtonColor = Color(0xFF4B3FA3);       // Purple button
const Color kLightScaffoldColor = Color(0xFFFFFFFF);     // White scaffold
const Color kLightLargeFontColor = Color(0xFF2D2A47);    // Deep purple text
const Color kLightSmallFontColor = Color(0xFF7C7A99);    // Muted lavender gray
const Color kLightCardColor = Color(0xFFD6CCFF);         // Very light purple card
const Color kLightBottomNavColor = Color(0xFFFDF1B2);    // Soft yellow nav
const Color kLightCardFontColor = Color(0xFF4B3FA3);     // Purple text on card
const Color kLightTextButtonColor = Color(0xFF6D5BFF);   // Medium purple text btn
const Color kLightVeryLargeFontColor = Color(0xFF1E193A);// Dark headline
const Color kLightPrimaryColor = Color(0xFF4B3FA3);      // Primary purple
const Color kLightSecondaryColor = Color(0xFFAFA5FF);    // Light purple secondary

// Dark Theme Palette (first image)
const Color kDarkBackgroundColor = Color(0xFF0A0035); // Dark navy background
const Color kGlowingTealColor = Color(0xFFB23BFF);    // Violet glow
const Color kGlowingBlueColor = Color(0xFFFFC800);    // Yellow glow
const Color kDarkSlateButtonColor = Color(0xFF3D1382);// Purple button bg
const Color kWhiteTextColor = Color(0xFFFFFFFF);      // White text

// Dark Mode
final ThemeData darkMode = ThemeData(
  appBarTheme: const AppBarTheme(backgroundColor: kPrimaryColor),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBackgroundColor,
  primaryColor: kPrimaryColor,
  colorScheme: const ColorScheme.dark(
    primary: kGlowingTealColor,
    secondary: kGlowingBlueColor,
    background: kDarkBackgroundColor,
    surface: kDarkSlateButtonColor,
  ),
  cardColor: kDarkCardBg,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: kWhiteTextColor),
    bodyLarge: TextStyle(color: kLargeTextColor, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(color: kFontColor),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kDarkTextFieldBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kGlowingTealColor),
    ),
    hintStyle: const TextStyle(color: kFontColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kcontinueButtonColor,
      foregroundColor: kDarkBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

// Light Mode
final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kLightScaffoldColor,
  primaryColor: kLightPrimaryColor,
  cardColor: kLightCardColor,
  colorScheme: const ColorScheme.light(
    primary: kLightPrimaryColor,
    secondary: kLightSecondaryColor,
    background: kLightScaffoldColor,
    surface: kLightCardColor,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: kLightCardFontColor),
    bodyLarge:
        TextStyle(color: kLightLargeFontColor, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: kLightSmallFontColor),
    headlineMedium: TextStyle(
        color: kLightVeryLargeFontColor,
        fontSize: 22,
        fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kLightCardColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: kLightPrimaryColor),
    ),
    hintStyle: const TextStyle(color: kLightSmallFontColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kLightButtonColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kLightTextButtonColor,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kLightBottomNavColor,
    selectedItemColor: kLightPrimaryColor,
    unselectedItemColor: kLightSmallFontColor,
  ),
);
