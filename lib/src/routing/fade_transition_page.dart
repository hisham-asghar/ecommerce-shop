import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage(
      {LocalKey? key, required Widget child, bool fullscreenDialog = false})
      : super(
          key: key,
          child: child,
          fullscreenDialog: fullscreenDialog,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        );
}
