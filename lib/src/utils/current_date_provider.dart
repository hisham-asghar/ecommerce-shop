import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateFunctionProvider = Provider<DateTime Function()>((ref) {
  return () => DateTime.now();
});
