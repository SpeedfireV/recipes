// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ImageWithMetadata {
  PlatformFile get image => throw _privateConstructorUsedError;
  bool get main => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImageWithMetadataCopyWith<ImageWithMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageWithMetadataCopyWith<$Res> {
  factory $ImageWithMetadataCopyWith(
          ImageWithMetadata value, $Res Function(ImageWithMetadata) then) =
      _$ImageWithMetadataCopyWithImpl<$Res, ImageWithMetadata>;
  @useResult
  $Res call({PlatformFile image, bool main});
}

/// @nodoc
class _$ImageWithMetadataCopyWithImpl<$Res, $Val extends ImageWithMetadata>
    implements $ImageWithMetadataCopyWith<$Res> {
  _$ImageWithMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? main = null,
  }) {
    return _then(_value.copyWith(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as PlatformFile,
      main: null == main
          ? _value.main
          : main // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImageWithMetadataCopyWith<$Res>
    implements $ImageWithMetadataCopyWith<$Res> {
  factory _$$_ImageWithMetadataCopyWith(_$_ImageWithMetadata value,
          $Res Function(_$_ImageWithMetadata) then) =
      __$$_ImageWithMetadataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PlatformFile image, bool main});
}

/// @nodoc
class __$$_ImageWithMetadataCopyWithImpl<$Res>
    extends _$ImageWithMetadataCopyWithImpl<$Res, _$_ImageWithMetadata>
    implements _$$_ImageWithMetadataCopyWith<$Res> {
  __$$_ImageWithMetadataCopyWithImpl(
      _$_ImageWithMetadata _value, $Res Function(_$_ImageWithMetadata) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = null,
    Object? main = null,
  }) {
    return _then(_$_ImageWithMetadata(
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as PlatformFile,
      main: null == main
          ? _value.main
          : main // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ImageWithMetadata implements _ImageWithMetadata {
  const _$_ImageWithMetadata({required this.image, required this.main});

  @override
  final PlatformFile image;
  @override
  final bool main;

  @override
  String toString() {
    return 'ImageWithMetadata(image: $image, main: $main)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImageWithMetadata &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.main, main) || other.main == main));
  }

  @override
  int get hashCode => Object.hash(runtimeType, image, main);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImageWithMetadataCopyWith<_$_ImageWithMetadata> get copyWith =>
      __$$_ImageWithMetadataCopyWithImpl<_$_ImageWithMetadata>(
          this, _$identity);
}

abstract class _ImageWithMetadata implements ImageWithMetadata {
  const factory _ImageWithMetadata(
      {required final PlatformFile image,
      required final bool main}) = _$_ImageWithMetadata;

  @override
  PlatformFile get image;
  @override
  bool get main;
  @override
  @JsonKey(ignore: true)
  _$$_ImageWithMetadataCopyWith<_$_ImageWithMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}
