import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_scrollable_card.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/address_service.dart';

/// A page where the user can enter and submit all the address details.
class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({Key? key, this.onDataSubmitted}) : super(key: key);
  final VoidCallback? onDataSubmitted;

  static const addressKey = Key('address');
  static const townCityKey = Key('townCity');
  static const stateKey = Key('state');
  static const postalCodeKey = Key('postalCode');
  static const countryKey = Key('country');

  static const scrollableKey = Key('addressPageScrollable');

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends ConsumerState<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  var _isLoading = false;

  Future<void> _submit() async {
    // TODO: Move all this logic into a controller
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final address = Address(
        address: _addressController.value.text,
        city: _cityController.value.text,
        state: _stateController.value.text,
        postalCode: _postalCodeController.value.text,
        country: _countryController.value.text,
      );
      final addressRepository = ref.read(addressServiceProvider);
      setState(() => _isLoading = true);
      await addressRepository.setUserAddress(address);
      setState(() => _isLoading = false);
      widget.onDataSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableCard(
      key: AddressScreen.scrollableKey,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddressFormField(
              formFieldKey: AddressScreen.addressKey,
              controller: _addressController,
              labelText: context.loc.address,
              keyboardType: TextInputType.streetAddress,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressScreen.townCityKey,
              controller: _cityController,
              labelText: context.loc.townCity,
              keyboardType: TextInputType.streetAddress,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressScreen.stateKey,
              controller: _stateController,
              labelText: context.loc.state,
              keyboardType: TextInputType.streetAddress,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressScreen.postalCodeKey,
              controller: _postalCodeController,
              labelText: context.loc.postalCode,
              keyboardType: TextInputType.streetAddress,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressScreen.countryKey,
              controller: _countryController,
              labelText: context.loc.country,
              keyboardType: TextInputType.streetAddress,
              enabled: !_isLoading,
            ),
            gapH8,
            PrimaryButton(
              text: context.loc.submit,
              onPressed: _submit,
              isLoading: _isLoading,
            )
          ],
        ),
      ),
    );
  }
}

// Reusable address form field
class AddressFormField extends StatelessWidget {
  const AddressFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.enabled = true,
    this.formFieldKey,
  }) : super(key: key);

  /// Controller used to read out the value in the parent widget
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;

  /// Whether the text field is enabled or not
  final bool enabled;

  /// Key used in the widget tests
  final Key? formFieldKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFieldKey,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        enabled: enabled,
      ),
      autocorrect: true,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      keyboardAppearance: Brightness.light,
      validator: (value) =>
          value?.isNotEmpty == true ? null : context.loc.cantBeEmpty,
    );
  }
}
