import '../../models/category.dart';

abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<Category>? categories;
  CategorySuccess(this.categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}
