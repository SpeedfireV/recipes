// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Recipe _$$_RecipeFromJson(Map<String, dynamic> json) => _$_Recipe(
      name: json['name'] as String,
      recipe: json['recipe'] as String,
      description: json['description'] as String,
      estimatedTime: json['estimatedTime'] as int,
      category: json['category'] as String,
    );

Map<String, dynamic> _$$_RecipeToJson(_$_Recipe instance) => <String, dynamic>{
      'name': instance.name,
      'recipe': instance.recipe,
      'description': instance.description,
      'estimatedTime': instance.estimatedTime,
      'category': instance.category,
    };
