import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_screen_model_state.freezed.dart';

@freezed
class CheckoutScreenModelState with _$CheckoutScreenModelState {
  const factory CheckoutScreenModelState.loading() = _Loading;
  const factory CheckoutScreenModelState.noTabs() = _NoTabs;
  const factory CheckoutScreenModelState.tab(int tabIndex) = _Tab;
}
