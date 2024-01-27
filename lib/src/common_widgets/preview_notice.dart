import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';

class PreviewNotice extends StatelessWidget {
  const PreviewNotice({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
                    context.loc.previewNotice,
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
