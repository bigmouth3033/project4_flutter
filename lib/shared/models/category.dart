import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  int? id;
  String? categoryName;
  String? description;
  String? categoryImage;

  Category({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
