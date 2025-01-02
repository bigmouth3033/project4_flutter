import 'package:flutter/material.dart';

abstract class ReservationState {}

class ReservationLoaded extends ReservationState {}

class ReservationFinishLoaded extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationError extends ReservationState {
  final String message;

  ReservationError(this.message);
}

class ReservationDateUpdated extends ReservationState {
  DateTimeRange selectedDateRange;
  ReservationDateUpdated(this.selectedDateRange);
}

class ReservationNotAvailable extends ReservationState {}
