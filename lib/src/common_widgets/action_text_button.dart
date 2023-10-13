import 'package:flutter/material.dart';

class ActionTextButton extends StatelessWidget {
  const ActionTextButton({Key? key, required this.text, this.onPressed})
      : super(key: key);
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white)),
      onPressed: onPressed,
    );
  }
}
