import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      routes: routes,
      home: const HomeScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
