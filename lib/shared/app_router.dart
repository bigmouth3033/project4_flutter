import 'package:project4_flutter/features/authentication/authentication.dart';
import 'package:project4_flutter/features/authentication/widget/user_login.dart';
import 'package:project4_flutter/home_screen.dart';

var routes = {
  "authentication": (context) => Authentication(),
  "home": (context) => const HomeScreen()
};
