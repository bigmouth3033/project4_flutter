import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/features/trips/bloc/trip_cubit/trip_state.dart';
import 'package:project4_flutter/features/trips/models/booking_minimize_dto.dart';
import 'package:project4_flutter/shared/models/custom_result.dart';

import '../../../../shared/api/api_service.dart';
import '../../../../shared/models/custom_paging.dart';
import '../../../../shared/utils/token_storage.dart';
import '../../models/trip_count.dart';

class TripCubit extends Cubit<TripState> {
  String? currentStatus;
  String? currentStartDate;
  String? currentEndDate;

  int currentPage = 0;
  bool hasMore = true;
  bool isLoading = false;

  TripCount? tripCount;

  TripCubit() : super(TripNotAvailable());

  final List<BookingMinimizeDto> bookingList = [];

  var apiService = ApiService();
  var tokenStorage = TokenStorage();

  void updateDateRange(DateTimeRange selectedDateRange) {
    emit(TripDateUpdated(selectedDateRange));
  }

  Future getBookingCount(startDate, endDate) async {
    try {
      Map<String, dynamic> params = {
        'startDate': startDate,
        'endDate': endDate,
      };

      var token = await tokenStorage.getToken();

      var response = await apiService.get("bookingCM/get_tripping_count",
          headers: {"Authorization": "Bearer $token"}, params: params);

      var customResult = CustomResult.fromJson(response);

      tripCount = TripCount.fromJson(customResult.data);

      if (customResult.status == 200) {}
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future getBookingList(status, startDate, endDate) async {
    if (currentStatus != status ||
        currentStartDate != startDate ||
        currentEndDate != endDate) {
      currentPage = 0;
      hasMore = true;
    }

    if (!hasMore) {
      emit(TripFinishLoaded());
      return;
    }

    if (hasMore) {
      emit(TripLoading());
    }

    try {
      isLoading = true;

      Map<String, dynamic> params = {
        'pageNumber': currentPage,
        'pageSize': 10,
        'status': status,
        'startDate': startDate,
        'endDate': endDate,
      };

      var token = await tokenStorage.getToken();

      var response = await apiService.get("bookingCM/get_user_booking",
          headers: {"Authorization": "Bearer $token"}, params: params);

      var customPaging = CustomPaging.fromJson(response);

      if (customPaging.status == 200) {
        var bookings = (customPaging.data as List).map((item) {
          return BookingMinimizeDto.fromJson(item);
        }).toList();

        hasMore = customPaging.hasNext;

        if (currentStatus != status ||
            currentStartDate != startDate ||
            currentEndDate != endDate) {
          bookingList.clear();
          bookingList.addAll(bookings);
          currentPage = 1;

          currentStatus = status;
          currentStartDate = startDate;
          currentEndDate = endDate;
        } else {
          bookingList.addAll(bookings);
          currentPage++;
        }

        emit(TripLoaded());
      } else {
        emit(TripError('Failed to load posts'));
      }
    } catch (ex) {
      emit(TripError(ex.toString()));
    } finally {
      isLoading = false;
    }
  }
}
