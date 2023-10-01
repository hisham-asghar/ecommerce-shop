import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/scrollable_page.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/address.dart';
import 'package:my_shop_ecommerce_flutter/src/services/data_store.dart';

class AddressPage extends ConsumerStatefulWidget {
  const AddressPage({Key? key, this.onDataSubmitted}) : super(key: key);
  final VoidCallback? onDataSubmitted;

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
    setState(() => _isSubmitted = true);
    if (_formKey.currentState!.validate()) {
      final address = Address(
        address: _addressController.value.text,
        city: _cityController.value.text,
        state: _stateController.value.text,
        postalCode: _postalCodeController.value.text,
        country: _countryController.value.text,
      );
      final dataStore = ref.read(dataStoreProvider);
      setState(() => _isLoading = true);
      await dataStore.submitAddress(address);
      setState(() => _isLoading = false);
      widget.onDataSubmitted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AddressFormField(
              controller: _addressController,
              labelText: 'Address',
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            const SizedBox(height: Sizes.p8),
            AddressFormField(
              controller: _cityController,
              labelText: 'Town/City',
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            const SizedBox(height: Sizes.p8),
            AddressFormField(
              controller: _stateController,
              labelText: 'State',
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            const SizedBox(height: Sizes.p8),
            AddressFormField(
              controller: _postalCodeController,
              labelText: 'Postal Code',
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            const SizedBox(height: Sizes.p8),
            AddressFormField(
              controller: _countryController,
              labelText: 'Country',
              keyboardType: TextInputType.streetAddress,
              submitted: _isSubmitted,
              enabled: !_isLoading,
            ),
            const SizedBox(height: Sizes.p8),
            PrimaryButton(
              text: 'Submit',
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
  }) : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool submitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
          value?.isNotEmpty == true ? null : 'Can\'t be empty',
    );
  }
}
