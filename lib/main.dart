import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/bloc/amenity_cubit/amenity_cubit.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/city_cubit/city_cubit.dart';
import 'package:project4_flutter/shared/bloc/favourite_cubit/favourite_cubit.dart';
import 'package:project4_flutter/shared/bloc/filter_cubit/filter_cubit.dart';
import 'package:project4_flutter/shared/bloc/travel_cubit/travel_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => TravelCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => UserCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (context) => FavouriteCubit(context.read<UserCubit>()),
        ),
        BlocProvider(
          create: (_) => FilterCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => AmenityCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => CategoryCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => CityCubit(), // Provide the Cubit
        ),
      ],
      child: const App(),
    ),
  );
}
