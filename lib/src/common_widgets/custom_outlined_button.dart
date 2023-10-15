import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton(
      {Key? key, required this.text, required this.color, this.onPressed})
      : super(key: key);
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: color,
          textStyle: Theme.of(context).textTheme.headline5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
