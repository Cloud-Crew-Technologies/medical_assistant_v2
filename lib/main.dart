import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medical_assistant_v2/app/theme/theme_data.dart';
import 'firebase_options.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('firebase initialized');

  // Flutter verserion 3.35.1
  print("successful");

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: lightMode,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
    ),
  );
}
