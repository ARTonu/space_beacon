import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app_routes.dart';
import 'app/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.signIn,
      getPages: pages,
      theme: lightTheme,
    ),
  );
}
