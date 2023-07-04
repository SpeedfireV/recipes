import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabSelectorProvider = StateProvider.autoDispose<int>((ref) => 0);
final passwordVisible = StateProvider.autoDispose<bool>((ref) => false);
