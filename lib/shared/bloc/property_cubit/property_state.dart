import 'package:project4_flutter/shared/models/property.dart';

abstract class PropertyState {}

class PropertyLoading extends PropertyState {
  final String message;
  PropertyLoading(this.message);
}

class PropertySuccess extends PropertyState {
  final Property property;
  PropertySuccess(this.property);
}

class PropertyError extends PropertyState {
  final String message;
  PropertyError(this.message);
}
