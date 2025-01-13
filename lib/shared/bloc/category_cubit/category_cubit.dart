import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project4_flutter/shared/api/api_service.dart';
import 'package:project4_flutter/shared/bloc/category_cubit/category_state.dart';

import '../../models/category.dart';
import '../../models/custom_result.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryLoading()) {
    getCategory();
  }
  var apiService = ApiService();
  Future<List<Category>?> getCategory() async {
    emit(CategoryLoading());
    try {
      var response = await apiService.get("categoryCM");
      var customResult = CustomResult.fromJson(response);

      if (customResult.status == 200) {
        var categories = (customResult.data as List).map((item) {
          return Category.fromJson(item);
        }).toList();
        emit(CategorySuccess(categories));
        return categories;
      }
      return null;
    } catch (ex) {
      emit(CategoryError(ex.toString()));
      return null;
    }
  }
}
