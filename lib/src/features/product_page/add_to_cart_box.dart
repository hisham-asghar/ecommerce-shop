import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_shop_ecommerce_flutter/src/common_widgets/primary_button.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';
import 'package:my_shop_ecommerce_flutter/src/models/cart.dart';
import 'package:my_shop_ecommerce_flutter/src/models/item.dart';
import 'package:my_shop_ecommerce_flutter/src/models/product.dart';

class AddToCartBox extends ConsumerStatefulWidget {
  const AddToCartBox({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  ConsumerState<AddToCartBox> createState() => _AddToCartBoxState();
}

class _AddToCartBoxState extends ConsumerState<AddToCartBox> {
  var _quantity = 1;

  void _addToCart() {
    final item = Item(
      productId: widget.product.id,
      quantity: _quantity,
    );
    ref.read(cartProvider.notifier).addItem(item);
    // TODO: Restore
    //ScaffoldMessenger.of(context)
    //    .showSnackBar(const SnackBar(content: Text('Added to cart')));
  }

  @override
  Widget build(BuildContext context) {
    // Alright let's do it with a dropdown
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quantity:'),
                ItemQuantityDropdown(
                  value: _quantity,
                  onChanged: (quantity) {
                    if (quantity != null) {
                      setState(() => _quantity = quantity);
                    }
                  },
                ),
              ],
            ),
            PrimaryButton(
              onPressed: _addToCart,
              text: 'Add to Cart',
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: GEEZ this is ugly! Make it better
class ItemQuantityDropdown extends StatelessWidget {
  const ItemQuantityDropdown({Key? key, required this.value, this.onChanged})
      : super(key: key);
  final int value;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: value,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: onChanged,
      items: [
        for (var i in [1, 2, 3, 4])
          DropdownMenuItem<int>(
            value: i,
            child: Text('$i'),
          ),
      ],
    );
  }
}
