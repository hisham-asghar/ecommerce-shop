import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_product_screen_model.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';
import 'package:my_shop_ecommerce_flutter/src/repositories/products_repository.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class AdminProductScreen extends ConsumerWidget {
  const AdminProductScreen({Key? key, this.productId}) : super(key: key);
  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(optionalProductProvider(productId));
    return AsyncValueWidget<Product?>(
      value: productValue,
      data: (product) => AdminProductScreenContents(product: product),
    );
  }
}

class AdminProductScreenContents extends ConsumerStatefulWidget {
  const AdminProductScreenContents({Key? key, this.product}) : super(key: key);
  final Product? product;

  @override
  ConsumerState<AdminProductScreenContents> createState() =>
      _AdminProductScreenContentsState();
}

class _AdminProductScreenContentsState
    extends ConsumerState<AdminProductScreenContents> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // error handling
    ref.listen<WidgetBasicState>(
      adminProductScreenModelProvider(widget.product),
      (_, state) => widgetStateErrorListener(context, state),
    );
    final model =
        ref.watch(adminProductScreenModelProvider(widget.product).notifier);
    final state = ref.watch(adminProductScreenModelProvider(widget.product));
    const autovalidateMode = AutovalidateMode.disabled;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'New Product' : 'Edit Product'),
        actions: [
          ActionTextButton(
            text: 'Save',
            onPressed: state.isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // This forces the image to reload
                      setState(() {});
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final model = ref.read(
                          adminProductScreenModelProvider(widget.product)
                              .notifier);
                      await model.submit();
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Product updated')),
                      );
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
                          if (model.imageUrl.isNotEmpty)
                            Image.network(model.imageUrl),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: model.imageUrl,
                            decoration: const InputDecoration(
                              label: Text('Image URL'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenModel.imageUrlValidator,
                            onSaved: (value) => model.imageUrl = value!,
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
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: model.title,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenModel.titleValidator,
                            onSaved: (value) => model.title = value!,
                          ),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: model.description,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              label: Text('Description'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenModel.descriptionValidator,
                            onSaved: (value) => model.description = value!,
                          ),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue:
                                model.price != 0 ? model.price.toString() : '',
                            decoration: const InputDecoration(
                              label: Text('Price'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenModel.priceValidator,
                            onSaved: (value) =>
                                model.price = double.parse(value!),
                          ),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: model.availableQuantity.toString(),
                            decoration: const InputDecoration(
                              label: Text('Available quantity'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenModel
                                .availableQuantityValidator,
                            onSaved: (value) =>
                                model.availableQuantity = int.parse(value!),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //}),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
