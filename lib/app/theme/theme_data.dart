import 'package:flutter/material.dart';

const Color kButtonColor = Color(0xFF90DDD4);
const Color kTextFieldColor = Color(0xFF020617);
const Color kFontColor = Color(0xFFC6C7CB);
const Color kSubtitleColor = Color(0xFF6C7685);
const Color kCardColor = Color(0xFF1E283B);
const Color kLargeTextColor = Color(0xFFE4E5E7);
const Color kPrimaryColor = Color(0xff14b7a5);
const Color kSecondaryColor = Color(0xFF1E283B);

// 🔹 Extra Colors (New)
const Color kNewTealColor = Color(0xFF13B7A5);     
const Color kDarkPrimaryBg = Color(0xFF1E293A);    
const Color kDarkCardBg = Color(0xFF384050);       
const Color kDarkTextFieldBg = Color(0xFF020617);  
const Color kDarkSecondaryBg = Color(0xFF1E293B);  
const Color kcontinueButtonColor = Color(0xFF26C6A8); // Continue button
const Color kLightGradientStart = Color(0xFF0C9185);  // Light gradient start
const Color kLightGradientEnd   = Color(0xFF2CD3BE);  // Light gradient end
const Color kBlueIconColor      = Color(0xFF4A90E2);  // Stomach/pain sessions
const Color kGreenIconColor     = Color(0xFF50C878);  // Eye/vision sessions
const Color kRedIconColor       = Color(0xFFFF6B6B);  // Knee/joint sessions
const Color kCyanIconColor      = Color(0xFF4ECDC4);  // Diabetes/blood sessions
const Color kDefaultIconColor   = Color(0xFF0C9185);  // Fallback session icon

//light theme
const Color kLightButtonColor = Color(0xFF14B7A5);
const Color kLightScaffoldColor = Color(0xFFFFFFFF);
const Color kLightLargeFontColor = Color(0xFF2D3747);
const Color kLightSmallFontColor = Color(0xFF828D9A);
const Color kLightCardColor = Color(0xFFF0F4F8);
const Color kLightBottomNavColor = Color(0xFF1E293B);
const Color kLightCardFontColor = Color(0xFF565E6B);
const Color kLightTextButtonColor = Color(0xFF50C7B9);
const Color kLightVeryLargeFontColor = Color(0xFF202A3C);
const Color kLightPrimaryColor = Color(0xFF14B7A5);
const Color kLightSecondaryColor = Color(0xFFF0F4F8);


// dark theme
const Color kDarkBackgroundColor = Color(0xFF000000);
const Color kGlowingTealColor = Color(0xFF00FFCC);
const Color kGlowingBlueColor = Color(0xFF0000FF);
const Color kDarkSlateButtonColor = Color(0xFF2F4F4F);
const Color kWhiteTextColor = Color(0xFFFFFFFF);

final ThemeData darkMode = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: kPrimaryColor),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBackgroundColor,
  primaryColor: kPrimaryColor,
  colorScheme: ColorScheme.dark(
    primary: kGlowingTealColor,
    secondary: kGlowingBlueColor,
    background: kDarkBackgroundColor,
    surface: kDarkSlateButtonColor,
  ),
  cardColor: kDarkSlateButtonColor,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: kWhiteTextColor),
    bodyLarge: TextStyle(color: kWhiteTextColor, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(color: kFontColor),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kDarkBackgroundColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kGlowingTealColor),
    ),
    hintStyle: TextStyle(color: kFontColor),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkSlateButtonColor,
      foregroundColor: kWhiteTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: kLightScaffoldColor,
  primaryColor: kLightPrimaryColor,
  cardColor: kLightCardColor,
  colorScheme: ColorScheme.light(
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
      borderSide: BorderSide(color: kLightPrimaryColor),
    ),
    hintStyle: TextStyle(color: kLightSmallFontColor),
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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: kLightBottomNavColor,
    selectedItemColor: kLightPrimaryColor,
    unselectedItemColor: kLightSmallFontColor,
  ),
);
