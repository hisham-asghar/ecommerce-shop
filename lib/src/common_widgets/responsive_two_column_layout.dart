import 'package:flutter/material.dart';

class ResponsiveTwoColumnLayout extends StatelessWidget {
  const ResponsiveTwoColumnLayout({
    Key? key,
    required this.startContent,
    required this.endContent,
    this.startFlex = 1,
    this.endFlex = 1,
    this.breakpoint = 600,
    required this.spacing,
    required this.padding,
  }) : super(key: key);
  final Widget startContent;
  final Widget endContent;
  final int startFlex;
  final int endFlex;
  final double breakpoint;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      return Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(flex: startFlex, child: startContent),
            SizedBox(width: spacing),
            Flexible(flex: endFlex, child: endContent),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              startContent,
              SizedBox(height: spacing),
              endContent,
            ],
          ),
        ),
      );
    }
  }
}
