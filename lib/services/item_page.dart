import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports/services/auth.dart';

final tabSelectorProvider = StateProvider.autoDispose<int>((ref) => 0);
final passwordVisibleProvider = StateProvider.autoDispose<bool>((ref) => false);
final loggedInProvider = StateProvider<bool>((ref) => AuthService.loggedIn());
final imagePositionProvider = StateProvider.autoDispose<int>((ref) => 0);
