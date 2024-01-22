import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

class ResponsiveTwoColumnLayout extends StatelessWidget {
  const ResponsiveTwoColumnLayout({
    Key? key,
    required this.startContent,
    required this.endContent,
    this.startFlex = 1,
    this.endFlex = 1,
    this.breakpoint = FormFactor.tablet,
    required this.spacing,
  }) : super(key: key);
  final Widget startContent;
  final Widget endContent;
  final int startFlex;
  final int endFlex;
  final double breakpoint;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: startFlex, child: startContent),
          Gap(spacing),
          Flexible(flex: endFlex, child: endContent),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          startContent,
          Gap(spacing),
          endContent,
        ],
      );
    }
  }
}
