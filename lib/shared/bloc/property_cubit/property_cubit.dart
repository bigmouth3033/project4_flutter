import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/api/property_detail_api.dart';
import 'package:project4_flutter/shared/bloc/property_cubit/property_state.dart';

class PropertyCubit extends Cubit<PropertyState> {
  PropertyCubit() : super(PropertyLoading("Loading..."));

  var propertyApi = PropertyDetailApi();

  Future<void> getProperty() async {
    emit(PropertyLoading("Loading..."));
    try {
      var property = await propertyApi.getProperty(687);
      if (property != null) {
        emit(PropertySuccess(property));
      } else {
        emit(PropertyError("Property not found"));
      }
    } catch (ex) {
      emit(PropertyError("Failed to load property: $ex"));
    }
  }
}
