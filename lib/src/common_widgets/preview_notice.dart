import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

/// A text bubble that overlays a message at the bottom-right of the screen
/// using a Stack widget (desktop-only).
/// Can be used to inform the user about pages/features that are not yet
/// complete.
class PreviewNotice extends StatelessWidget {
  const PreviewNotice({Key? key, required this.child, required this.notice})
      : super(key: key);
  final Widget child;
  final String notice;

  @override
  Widget build(BuildContext context) {
    // ! MediaQuery is used on the assumption that the widget takes up the full
    // ! width of the screen. If that's not the case, LayoutBuilder should be
    // ! used instead.
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        child,
        if (screenWidth > 1200)
          Positioned(
            right: Sizes.p24,
            bottom: Sizes.p24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Sizes.p16),
              ),
              child: SizedBox(
                width: (screenWidth - FormFactor.desktop - Sizes.p48) / 2,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Text(
                    notice,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
