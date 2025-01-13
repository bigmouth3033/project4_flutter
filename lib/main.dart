import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/bloc/booking/booking.dart';
import 'package:project4_flutter/shared/bloc/booking/date_booking.dart';
import 'package:project4_flutter/shared/bloc/booking/guest_booking.dart';
import 'package:project4_flutter/shared/bloc/booking/transaction.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/policy_cubit/policy_cubit.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_cubit.dart';
import 'package:project4_flutter/shared/bloc/read_review_cubit/review_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'app.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => UserCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => PropertyCubit(),
        ),
        BlocProvider(
          create: (_) => ReviewCubit(),
        ),
        BlocProvider(
          create: (_) => PolicyCubit(),
        ),
        BlocProvider(
          create: (_) => DateBookingCubit(),
        ),
        BlocProvider(
          create: (_) => GuestBookingCubit(),
        ),
        BlocProvider(
          create: (_) => BookingCubit(),
        ),
        BlocProvider(
          create: (_) => TransactionCubit(),
        ),
      ],
      child: const App(),
    ),
  );
}
