import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

/// Helper widget class to map an [AsyncValue] to a given data widget,
/// using default widgets for loading and error states
/// See this article for more info:
/// https://codewithandrea.com/articles/async-value-widget-riverpod/
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({Key? key, required this.value, required this.data})
      : super(key: key);
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => AsyncValueErrorWidget(e, st),
    );
  }
}

/// Sliver equivalent of [AsyncValueWidget]
class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget(
      {Key? key, required this.value, required this.data})
      : super(key: key);
  final AsyncValue<T> value;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())),
      error: (e, st) => SliverToBoxAdapter(
        child: AsyncValueErrorWidget(e, st),
      ),
    );
  }
}

class AsyncValueErrorWidget extends StatelessWidget {
  const AsyncValueErrorWidget(this.error, this.stackTrace, {Key? key})
      : super(key: key);
  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ErrorMessageWidget(error.toString()),
          if (stackTrace != null) ...[
            gapH8,
            Text(stackTrace.toString()),
          ]
        ],
      ),
    );
  }
}

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(this.errorMessage, {Key? key}) : super(key: key);
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.red),
    );
  }
}
