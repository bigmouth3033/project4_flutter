import 'package:project4_flutter/features/authentication/authentication.dart';
import 'package:project4_flutter/features/property_detail/property_detail.dart';

import 'package:project4_flutter/home_screen.dart';

var routes = {
  "authentication": (context) => Authentication(),
  "home": (context) => const HomeScreen(),
  "property_detail": (context) =>  PropertyDetail(),
};
