import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project4_flutter/features/splash_screen/splash_screen.dart';
import 'package:project4_flutter/home_screen.dart';
import 'package:project4_flutter/main.dart';
import 'package:project4_flutter/shared/app_router.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      routes: routes,
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
