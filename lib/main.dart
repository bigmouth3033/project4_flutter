import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project4_flutter/shared/bloc/listing_list_cubit/listing_list_cubit.dart';
import 'package:project4_flutter/shared/bloc/message_room_cubit/message_room_cubit.dart';
import 'package:project4_flutter/shared/api/firebase_api.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/property_calendar_cubit/property_calendar_cubit.dart';
import 'package:project4_flutter/shared/bloc/reservation_cubit/reservation_cubit.dart';
import 'package:project4_flutter/shared/bloc/trip_cubit/trip_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:project4_flutter/shared/models/dchc_dto.dart';
import 'package:provider/provider.dart';
import 'app.dart';

late String? fcmToken;
final navigatorKey = GlobalKey<NavigatorState>();
final format = DateFormat.yMd();
late DCHCDto dchc;

Future loadJsonAsset() async {
  final String jsonString =
      await rootBundle.loadString('assets/data/dchc.json');
  dchc = DCHCDto.fromJson(jsonDecode(jsonString));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  fcmToken = await FirebaseApi().initNotifications();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final androidSdkVersion =
      deviceInfo is AndroidDeviceInfo ? deviceInfo.version.sdkInt : 0;
  await loadJsonAsset();

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => ListingListCubit(), // Provide the Cubit
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
        BlocProvider(
          create: (_) => MessageRoomCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => PropertyCalendarCubit(), // Provide the Cubit
        ),
      ],
      child: App(androidSdkVersion: androidSdkVersion),
    ),
  );
}
