import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/action_text_button.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/async_value_widget.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/custom_image.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_center.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/responsive_two_column_layout.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/application/products_service.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/admin/admin_product_screen_controller.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/presentation/admin/product_validator.dart';
import 'package:my_shop_ecommerce_flutter/src/localization/app_localizations_context.dart';
import 'package:my_shop_ecommerce_flutter/src/features/products/domain/product.dart';
import 'package:my_shop_ecommerce_flutter/src/utils/async_value_ui.dart';

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
    ref.listen<VoidAsyncValue>(
      adminProductScreenControllerProvider(widget.product),
      (_, state) => state.showAlertDialogOnError(context),
    );
    final model = ref
        .watch(adminProductScreenControllerProvider(widget.product).notifier);
    final state =
        ref.watch(adminProductScreenControllerProvider(widget.product));
    const autovalidateMode = AutovalidateMode.disabled;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product == null
              ? context.loc.newProduct
              : context.loc.editProduct,
        ),
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
                          adminProductScreenControllerProvider(widget.product)
                              .notifier);
                      await model.submit();
                      context.pop();
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            context.loc.productUpdated,
                          ),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
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
                        CustomImage(imageUrl: model.imageUrl),
                      gapH8,
                      TextFormField(
                        enabled: !state.isLoading,
                        initialValue: model.imageUrl,
                        decoration: InputDecoration(
                          label: Text(
                            context.loc.imageUrl,
                          ),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator: ref
                            .read(productValidatorProvider)
                            .imageUrlValidator,
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
                        enabled: !state.isLoading,
                        initialValue: model.title,
                        decoration: InputDecoration(
                          label: Text(context.loc.title),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator:
                            ref.read(productValidatorProvider).titleValidator,
                        onSaved: (value) => model.title = value!,
                      ),
                      gapH8,
                      TextFormField(
                        enabled: !state.isLoading,
                        initialValue: model.description,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          label: Text(
                            context.loc.description,
                          ),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator: ref
                            .read(productValidatorProvider)
                            .descriptionValidator,
                        onSaved: (value) => model.description = value!,
                      ),
                      gapH8,
                      TextFormField(
                        enabled: !state.isLoading,
                        initialValue:
                            model.price != 0 ? model.price.toString() : '',
                        decoration: InputDecoration(
                          label: Text(
                            context.loc.price,
                          ),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator:
                            ref.read(productValidatorProvider).priceValidator,
                        onSaved: (value) => model.price = double.parse(value!),
                      ),
                      TextFormField(
                        enabled: !state.isLoading,
                        initialValue: model.availableQuantity.toString(),
                        decoration: InputDecoration(
                          label: Text(
                            context.loc.availableQuantity,
                          ),
                        ),
                        autovalidateMode: autovalidateMode,
                        validator: ref
                            .read(productValidatorProvider)
                            .availableQuantityValidator,
                        onSaved: (value) =>
                            model.availableQuantity = int.parse(value!),
                      ),
                    ],
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
