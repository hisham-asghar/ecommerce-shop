import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_scrollable_card.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/database/address/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/address_service.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({Key? key, this.onDataSubmitted}) : super(key: key);
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

class _AddressPageState extends ConsumerState<AddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  /// Used to decide whether to show the text fields error hints
  var _isSubmitted = false;
  var _isLoading = false;

  Future<void> _submit() async {
    // TODO: Move all this logic into a controller
    setState(() => _isSubmitted = true);
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
      await addressRepository.submitAddress(address);
      setState(() => _isLoading = false);
      widget.onDataSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScrollableCard(
      key: AddressPage.scrollableKey,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddressFormField(
              formFieldKey: AddressPage.addressKey,
              controller: _addressController,
              labelText: context.loc.address,
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressPage.townCityKey,
              controller: _cityController,
              labelText: context.loc.townCity,
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressPage.stateKey,
              controller: _stateController,
              labelText: context.loc.state,
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressPage.postalCodeKey,
              controller: _postalCodeController,
              labelText: context.loc.postalCode,
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            gapH8,
            AddressFormField(
              formFieldKey: AddressPage.countryKey,
              controller: _countryController,
              labelText: context.loc.country,
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
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

class AddressFormField extends StatelessWidget {
  const AddressFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.enabled = true,
    this.submitted = false,
    this.formFieldKey,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool submitted;
  final Key? formFieldKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formFieldKey,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // errorText: submitted && controller.value.text.isEmpty
        //     ? 'Can\'t be empty'
        //     : null,
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
