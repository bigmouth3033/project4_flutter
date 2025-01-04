import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/features/trips/models/booking_minimize_dto.dart';
import 'package:project4_flutter/shared/bloc/property_calendar_cubit/property_calendar_cubit.dart';
import 'package:project4_flutter/shared/bloc/property_calendar_cubit/property_calendar_state.dart';
import 'package:project4_flutter/shared/widgets/loading_icon.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

class PropertyCalendar extends StatefulWidget {
  const PropertyCalendar({required this.propertyId, super.key});

  final int propertyId;

  @override
  State<PropertyCalendar> createState() => _PropertyCalendarState();
}

class _PropertyCalendarState extends State<PropertyCalendar> {
  PropertyCalendarCubit getPropertyCalendarCubit() {
    return context.read<PropertyCalendarCubit>();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPropertyCalendarCubit().fetchBooking(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<PropertyCalendarCubit, PropertyCalendarState>(
        builder: (context, state) {
          List<BookingMinimizeDto> bookings =
              getPropertyCalendarCubit().bookings;

          if (state is PropertyCalendarLoading) {
            return const LoadingIcon(size: 50);
          }

          if (state is PropertyCalendarFinishLoaded) {
            return Text(
              "a",
              style: TextStyle(color: Colors.black.withOpacity(0.4)),
            );
          }
          return const Text("a");
        },
      ),
    );
  }
}
