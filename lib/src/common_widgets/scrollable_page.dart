import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

// TODO: Find better name?
class ScrollablePage extends StatelessWidget {
  const ScrollablePage({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            width: min(constraints.maxWidth, 600),
            padding: const EdgeInsets.all(Sizes.p16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.p16),
                child: child,
              ),
            ),
          );
        }),
      ),
    );
  }
}
