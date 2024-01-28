import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

/// Reusable widget for showing a child with a maximum content width constraint.
/// If available width is larger than the maximum width, the child will be
/// centered.
/// If available width is smaller than the maximum width, the child use all the
/// available width.
class CenteredBox extends StatelessWidget {
  const CenteredBox({
    Key? key,
    this.maxContentWidth = FormFactor.desktop,
    this.padding = EdgeInsets.zero,
    required this.child,
  }) : super(key: key);
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxContentWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Sliver-equivalent of [CenteredBox].
class CenteredSliverToBoxAdapter extends StatelessWidget {
  const CenteredSliverToBoxAdapter({
    Key? key,
    this.maxContentWidth = FormFactor.desktop,
    this.padding = EdgeInsets.zero,
    required this.child,
  }) : super(key: key);
  final double maxContentWidth;
  final EdgeInsetsGeometry padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CenteredBox(
        maxContentWidth: maxContentWidth,
        padding: padding,
        child: child,
      ),
    );
  }
}
