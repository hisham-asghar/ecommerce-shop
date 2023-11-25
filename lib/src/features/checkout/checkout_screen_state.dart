import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_screen_state.freezed.dart';

@freezed
class CheckoutScreenState with _$CheckoutScreenState {
  const factory CheckoutScreenState.loading() = _Loading;
  const factory CheckoutScreenState.noTabs() = _NoTabs;
  const factory CheckoutScreenState.tab(int tabIndex) = _Tab;
}
