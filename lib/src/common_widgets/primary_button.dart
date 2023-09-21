import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key, required this.text, this.isLoading = false, this.onPressed})
      : super(key: key);
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    // TODO: Do not hardcode
                    .copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
