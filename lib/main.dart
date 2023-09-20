import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/services/provider_logger.dart';

import 'src/app.dart';

void main() async {
  runApp(ProviderScope(
    observers: [ProviderLogger()],
    child: const MyApp(),
  ));
}
