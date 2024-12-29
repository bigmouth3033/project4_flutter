import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => CategoryCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => UserCubit(), // Provide the Cubit
        ),
        BlocProvider(
          create: (_) => PropertyCubit(), // Provide the Cubit
        ),
      ],
      child: const App(),
    ),
  );
}
