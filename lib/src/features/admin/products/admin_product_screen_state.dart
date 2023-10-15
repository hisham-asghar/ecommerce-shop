import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_product_screen_state.freezed.dart';

@freezed
abstract class AdminProductScreenState with _$AdminProductScreenState {
  const factory AdminProductScreenState.loading() = _Loading;
  const factory AdminProductScreenState.notLoading() = _NotLoading;
  const factory AdminProductScreenState.error(String message) = _Error;
}

// class AdminProductScreenState {
//   AdminProductScreenState({required this.isLoading});
//   final bool isLoading;
// }
