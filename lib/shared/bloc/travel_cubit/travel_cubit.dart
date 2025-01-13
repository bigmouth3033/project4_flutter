import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project4_flutter/shared/api/api_service.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_cubit.dart';
import 'package:project4_flutter/shared/bloc/travel_cubit/travel_state.dart';
import 'package:project4_flutter/shared/models/custom_paging.dart';
import 'package:project4_flutter/shared/models/travel_entity.dart';
import 'package:project4_flutter/shared/utils/token_storage.dart';

class TravelCubit extends Cubit<TravelState> {
  var apiService = ApiService();

  var tokenStorage = TokenStorage();

  String? currentStartDate;
  String? currentEndDate;
  int currentPage = 0;
  bool hasMore = true;
  bool isLoading = false;
  List<TravelEntity> travelList = [];
  int? categoryId;
  List<int>? amenityIdList = [];
  String? propertyType;
  List<double>? priceRange = [0, 1000];
  String? isInstant;
  bool? isSelfCheckIn;
  bool? isPetAllow;
  int room = 1;
  int bed = 1;
  int bathRoom = 1;
  int totalCount = 0;

  TravelCubit() : super(TravelNotAvailable());

  Future reRender() async {
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changeCategory(int? category) async {
    categoryId = category;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changePropertyType(String? proType) async {
    propertyType = proType;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changePrice(List<double>? prices) async {
    priceRange = prices;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changeInstant(String? ins) async {
    isInstant = ins;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changeSelfCheckIn(bool? self) async {
    isSelfCheckIn = self;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changePet(bool? pet) async {
    isPetAllow = pet;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changeRoom(int r) async {
    room = r;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changeBed(int b) async {
    bed = b;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  } //fetch data => Future

  Future changeBathRoom(int bath) async {
    bathRoom = bath;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  //fetch data => Future
  Future changeAmenity(List<int>? amenityList) async {
    amenityIdList = amenityList;
    currentPage = 0;
    hasMore = true;
    travelList.clear();
    await getPropertyList();
  }

  Future<void> getPropertyList() async {
    if (!hasMore) {
      emit(TravelFinishLoaded());
      return;
    }

    if (hasMore) {
      emit(TravelLoading());
    }

    try {
      isLoading = true;
      // Lấy ngày hôm nay và ngày mai
      DateTime today = DateTime.now();
      DateTime tomorrow = today.add(const Duration(days: 1));

      // Định dạng ngày theo kiểu "yyyy-MM-dd"
      String formattedToday = DateFormat('yyyy-MM-dd').format(today);
      String formattedTomorrow = DateFormat('yyyy-MM-dd').format(tomorrow);

      Map<String, dynamic> params = {
        'pageNumber': currentPage,
        'pageSize': 10,
        'categoryId': categoryId,
        'propertyType': propertyType,
        'amenities': Uri.encodeComponent(jsonEncode(amenityIdList)),
        'isInstant': isInstant,
        'isSelfCheckIn': isSelfCheckIn,
        'isPetAllowed': isPetAllow,
        'priceRange': Uri.encodeComponent(jsonEncode(priceRange)),
        'room': room,
        'bed': bed,
        'bathRoom': bathRoom,
        'guest': null,
        'province': null,
        'district': null,
        'ward': null,
        'startDate': formattedToday,
        'endDate': formattedTomorrow,
      };
      var response =
          await apiService.get("listingCM/propertyCMflutter", params: params);
      var customPaging = CustomPaging.fromJson(response);

      if (customPaging.status == 200) {
        travelList.addAll(customPaging.data);
        hasMore = customPaging.hasNext;
        totalCount = customPaging.totalCount;

        currentPage++;
        emit(TravelLoaded());
      } else {
        emit(TravelError('Failed to load properties'));
      }
    } catch (ex) {
      emit(TravelError(ex.toString()));
    } finally {
      isLoading = false;
    }
  }
}
