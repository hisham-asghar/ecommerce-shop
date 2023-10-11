import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_product_screen_view_model.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/currency_formatter.dart';

class AdminProductScreen extends ConsumerWidget {
  const AdminProductScreen({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    final productsRepository = ref.watch(productsRepositoryProvider);
    // TODO: Make editable
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: FormFactor.desktop,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: ResponsiveTwoColumnLayout(
                startContent: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p16),
                    // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
                    child: Image.network(product.imageUrl),
                  ),
                ),
                spacing: Sizes.p16,
                endContent: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: AdminEditProductDetails(
                      viewModel: AdminProductScreenViewModel(
                        productsRepository: productsRepository,
                        product: product,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminEditProductDetails extends ConsumerStatefulWidget {
  const AdminEditProductDetails({Key? key, required this.viewModel})
      : super(key: key);
  final AdminProductScreenViewModel viewModel;

  @override
  ConsumerState<AdminEditProductDetails> createState() =>
      _AdminEditProductDetailsState();
}

class _AdminEditProductDetailsState
    extends ConsumerState<AdminEditProductDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const autovalidateMode = AutovalidateMode.disabled;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: widget.viewModel.title,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
            autovalidateMode: autovalidateMode,
            validator: AdminProductScreenViewModel.titleValidator,
            onSaved: (value) => widget.viewModel.title = value!,
          ),
          const SizedBox(height: Sizes.p8),
          TextFormField(
            initialValue: widget.viewModel.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              label: Text('Description'),
            ),
            autovalidateMode: autovalidateMode,
            validator: AdminProductScreenViewModel.descriptionValidator,
            onSaved: (value) => widget.viewModel.description = value!,
          ),
          const SizedBox(height: Sizes.p8),
          TextFormField(
            initialValue: widget.viewModel.price != 0
                ? widget.viewModel.price.toString()
                : '',
            decoration: const InputDecoration(
              label: Text('Price'),
            ),
            autovalidateMode: autovalidateMode,
            validator: AdminProductScreenViewModel.priceValidator,
            onSaved: (value) => widget.viewModel.price = double.parse(value!),
          ),
          const SizedBox(height: Sizes.p8),
          PrimaryButton(
            text: 'Save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.viewModel.submit();
              }
            },
          ),
        ],
      ),
    );
  }
}
