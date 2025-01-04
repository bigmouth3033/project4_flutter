import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project4_flutter/features/trips/models/booking_minimize_dto.dart';
import 'package:project4_flutter/shared/bloc/listing_list_cubit/listing_list_state.dart';
import 'package:project4_flutter/shared/bloc/property_calendar_cubit/property_calendar_state.dart';
import 'package:project4_flutter/shared/bloc/trip_cubit/trip_state.dart';
import 'package:project4_flutter/shared/models/custom_result.dart';

import '../../../../shared/api/api_service.dart';
import '../../../../shared/models/custom_paging.dart';
import '../../../../shared/utils/token_storage.dart';
import '../../../features/trips/models/trip_count.dart';

class PropertyCalendarCubit extends Cubit<PropertyCalendarState> {
  int? propertyId;
  bool isLoading = false;
  var tokenStorage = TokenStorage();
  final List<BookingMinimizeDto> bookings = [];
  var apiService = ApiService();

  PropertyCalendarCubit() : super(PropertyCalendarStateNotAvailable());

  Future fetchBooking(propertyId) async {
    try {
      isLoading = true;

      emit(PropertyCalendarLoading());

      Map<String, dynamic> params = {
        'propertyId': propertyId,
      };

      var token = await tokenStorage.getToken();

      var response = await apiService.get("bookingCM/property_booking",
          headers: {"Authorization": "Bearer $token"}, params: params);

      var customResult = CustomResult.fromJson(response);

      if (customResult.status == 200) {
        bookings.clear();
        bookings.addAll((customResult.data as List).map((item) {
          return BookingMinimizeDto.fromJson(item);
        }).toList());

        emit(PropertyCalendarFinishLoaded());
      } else {
        emit(PropertyCalendarStateError('Failed to load posts'));
      }
    } catch (ex) {
      emit(PropertyCalendarStateError(ex.toString()));
    } finally {
      isLoading = false;
    }
  }
}
