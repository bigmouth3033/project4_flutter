import 'package:flutter/material.dart';

abstract class PropertyCalendarState {}

class PropertyCalendarFinishLoaded extends PropertyCalendarState {}

class PropertyCalendarLoading extends PropertyCalendarState {}

class PropertyCalendarStateError extends PropertyCalendarState {
  final String message;

  PropertyCalendarStateError(this.message);
}

class PropertyCalendarStateNotAvailable extends PropertyCalendarState {}
