import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/admin/products/admin_product_screen_model.dart';
import 'package:my_shop_ecommerce_flutter/src/state/widget_basic_state.dart';

class AdminProductScreen extends ConsumerStatefulWidget {
  const AdminProductScreen({Key? key, required this.productId})
      : super(key: key);
  final String? productId;

  @override
  ConsumerState<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends ConsumerState<AdminProductScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // error handling
    ref.listen(
      adminProductScreenModelProvider(widget.productId),
      (WidgetBasicState state) => widgetStateErrorListener(context, state),
    );
    final viewModel =
        ref.watch(adminProductScreenModelProvider(widget.productId).notifier);
    final state = ref.watch(adminProductScreenModelProvider(widget.productId));
    const autovalidateMode = AutovalidateMode.disabled;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? 'New Product' : 'Edit Product'),
        actions: [
          ActionTextButton(
            text: 'Save',
            onPressed: state == const WidgetBasicState.loading()
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // This forces the image to reload
                      setState(() {});
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      final viewModel = ref.read(
                          adminProductScreenModelProvider(widget.productId)
                              .notifier);
                      await viewModel.submit();
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
                          if (viewModel.imageUrl.isNotEmpty)
                            Image.network(viewModel.imageUrl),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: viewModel.imageUrl,
                            decoration: const InputDecoration(
                              label: Text('Image URL'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenModel.imageUrlValidator,
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
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: viewModel.title,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenModel.titleValidator,
                            onSaved: (value) => viewModel.title = value!,
                          ),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: viewModel.description,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: const InputDecoration(
                              label: Text('Description'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator:
                                AdminProductScreenModel.descriptionValidator,
                            onSaved: (value) => viewModel.description = value!,
                          ),
                          const SizedBox(height: Sizes.p8),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue: viewModel.price != 0
                                ? viewModel.price.toString()
                                : '',
                            decoration: const InputDecoration(
                              label: Text('Price'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenModel.priceValidator,
                            onSaved: (value) =>
                                viewModel.price = double.parse(value!),
                          ),
                          TextFormField(
                            enabled: state != const WidgetBasicState.loading(),
                            initialValue:
                                viewModel.availableQuantity.toString(),
                            decoration: const InputDecoration(
                              label: Text('Available quantity'),
                            ),
                            autovalidateMode: autovalidateMode,
                            validator: AdminProductScreenModel
                                .availableQuantityValidator,
                            onSaved: (value) =>
                                viewModel.availableQuantity = int.parse(value!),
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
