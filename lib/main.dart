import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiology_and_lab_app/core/routers/app_router.dart';
import 'package:radiology_and_lab_app/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:radiology_and_lab_app/firebase_options.dart';
import 'package:radiology_and_lab_app/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initGetIt();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => RadiologyApp()),
  );
}

class RadiologyApp extends StatelessWidget {
  const RadiologyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Radiology & Lab System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
