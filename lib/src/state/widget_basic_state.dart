import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_basic_state.freezed.dart';

@freezed
class WidgetBasicState with _$WidgetBasicState {
  const factory WidgetBasicState.loading() = _Loading;
  const factory WidgetBasicState.notLoading() = _NotLoading;
  const factory WidgetBasicState.error(String message) = _Error;
}

extension WidgetBasicStateX on WidgetBasicState {
  bool get isLoading => this == const WidgetBasicState.loading();

  void showSnackBarOnError(BuildContext context) => whenOrNull(
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      );
}
