import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_product_screen_view_model.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';

class AdminProductScreen extends ConsumerStatefulWidget {
  const AdminProductScreen({Key? key, required this.product}) : super(key: key);
  final Product? product;

  @override
  ConsumerState<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends ConsumerState<AdminProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final viewModel = AdminProductScreenViewModel(
    product: widget.product,
    productsRepository: ref.read(productsRepositoryProvider),
  );

  @override
  Widget build(BuildContext context) {
    const autovalidateMode = AutovalidateMode.disabled;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'New Product' : 'Edit Product'),
        actions: [
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // This forces the image to reload
                setState(() {});
                viewModel.submit();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: FormFactor.desktop,
            child: Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Form(
                key: _formKey,
                child: ResponsiveTwoColumnLayout(
                  startContent: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Column(
                        children: [
                          // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
                          if (viewModel.imageUrl.isNotEmpty)
                            Image.network(viewModel.imageUrl),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            initialValue: viewModel.imageUrl,
                            decoration: const InputDecoration(
                              label: Text('Image URL'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenViewModel.imageUrlValidator,
                            onSaved: (value) => viewModel.imageUrl = value!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  spacing: Sizes.p16,
                  endContent: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            initialValue: viewModel.title,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenViewModel.titleValidator,
                            onSaved: (value) => viewModel.title = value!,
                          ),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            initialValue: viewModel.description,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              label: Text('Description'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenViewModel
                                .descriptionValidator,
                            onSaved: (value) => viewModel.description = value!,
                          ),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            initialValue: viewModel.price != 0
                                ? viewModel.price.toString()
                                : '',
                            decoration: const InputDecoration(
                              label: Text('Price'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenViewModel.priceValidator,
                            onSaved: (value) =>
                                viewModel.price = double.parse(value!),
                          ),
                          TextFormField(
                            initialValue: viewModel.availableQuantity != 0
                                ? viewModel.availableQuantity.toString()
                                : '',
                            decoration: const InputDecoration(
                              label: Text('Available quantity'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenViewModel
                                .availableQuantityValidator,
                            onSaved: (value) =>
                                viewModel.availableQuantity = int.parse(value!),
                          ),
                        ],
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
