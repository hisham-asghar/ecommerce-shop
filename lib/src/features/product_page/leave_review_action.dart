import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/custom_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/routing/app_router.dart';
import 'package:my_shop_ecommerce_flutter/src/services/reviews_service.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/date_formatter.dart';

class LeaveReviewAction extends ConsumerWidget {
  const LeaveReviewAction({Key? key, required this.productId})
      : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchaseValue = ref.watch(userPurchaseProvider(productId));
    final purchase = purchaseValue.value;
    if (purchase != null) {
      final dateFormatted =
          ref.watch(dateFormatterProvider).format(purchase.orderDate);
      return Column(
        children: [
          const Divider(),
          gapH8,
          ResponsiveTwoColumnLayout(
            spacing: Sizes.p16,
            breakpoint: 150,
            startFlex: 3,
            endFlex: 2,
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            startContent: Text(context.loc.purchasedOnDate(dateFormatted)),
            endContent: CustomTextButton(
              text: context.loc.leaveReview,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.green[700]),
              onPressed: () => context.goNamed(AppRoute.leaveReview.name,
                  params: {'id': productId}),
            ),
          ),
          gapH8,
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
