import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient(
      {required String name,
      required Uint8List image,
      required String volume}) = _Ingredient;
}
