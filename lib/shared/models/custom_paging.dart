import 'package:json_annotation/json_annotation.dart';
import 'package:project4_flutter/shared/models/travel_entity.dart';

part 'custom_paging.g.dart';

@JsonSerializable()
class CustomPaging {
  int status;
  String message;
  int currentPage;
  int totalPages;
  int pageSize;
  int totalCount;
  bool hasPrevious;
  bool hasNext;
  List<TravelEntity> data;

  CustomPaging(
      {required this.status,
        required this.message,
        required this.currentPage,
        required this.totalPages,
        required this.pageSize,
        required this.totalCount,
        required this.hasPrevious,
        required this.hasNext,
        required this.data});

  factory CustomPaging.fromJson(Map<String, dynamic> json) =>
      _$CustomPagingFromJson(json);

  Map<String, dynamic> toJson() => _$CustomPagingToJson(this);
}