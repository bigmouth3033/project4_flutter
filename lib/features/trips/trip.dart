import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/features/trips/bloc/trip_cubit/trip_cubit.dart';
import 'package:project4_flutter/features/trips/widgets/user_trip.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_cubit.dart';
import 'package:project4_flutter/shared/bloc/user_cubit/user_state.dart';
import 'package:project4_flutter/shared/widgets/loading_icon.dart';
import 'package:provider/provider.dart';

class Trip extends StatefulWidget {
  const Trip({super.key});

  @override
  State<Trip> createState() => _TripState();
}

class _TripState extends State<Trip> {
  String dropDownSelectOption = 'Trips';

  final List<String> list = <String>[
    'Trips',
    'Reservation',
    'Refund',
    'Review'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          return const UserTrip();
        }

        if (state is UserNotLogin) {
          return const Center(
            child: Text("Please login to see your trip history"),
          );
        }

        if (state is UserLoading) {
          return const LoadingIcon(size: 60);
        }

        return const Text("Loading...");
      },
    );
  }
}
