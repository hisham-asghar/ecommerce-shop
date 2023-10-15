import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_basic_state.freezed.dart';

@freezed
class WidgetBasicState with _$WidgetBasicState {
  const factory WidgetBasicState.loading() = _Loading;
  const factory WidgetBasicState.notLoading() = _NotLoading;
  const factory WidgetBasicState.error(String message) = _Error;
}

// global function to be used when handling WidgetBasicState changes with ref.listen()
void widgetStateErrorListener(BuildContext context, WidgetBasicState state) {
  state.whenOrNull(
    error: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    },
  );
}
