import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'image.freezed.dart';

@freezed
class ImageWithMetadata with _$ImageWithMetadata {
  const factory ImageWithMetadata({
    required PlatformFile image,
    required bool main,
  }) = _ImageWithMetadata;
}
