import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project4_flutter/features/trips/bloc/trip_cubit/trip_cubit.dart';
import 'package:project4_flutter/shared/api/firebase_api.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/trips/bloc/reservation_cubit/reservation_cubit.dart';

late String? fcmToken;
final navigatorKey = GlobalKey<NavigatorState>();
final format = DateFormat.yMd();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  fcmToken = await FirebaseApi().initNotifications();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => TripCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => ReservationCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => UserCubit(), // Provide the Cubit
        ),
      ],
      child: const App(),
    ),
  );
}
