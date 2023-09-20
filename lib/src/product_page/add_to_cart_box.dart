import 'package:flutter/material.dart';
import 'package:my_shop_ecommerce_flutter/src/constants/app_sizes.dart';

class AddToCartBox extends StatefulWidget {
  const AddToCartBox({Key? key}) : super(key: key);

  @override
  State<AddToCartBox> createState() => _AddToCartBoxState();
}

class _AddToCartBoxState extends State<AddToCartBox> {
  var _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Alright let's do it with a dropdown
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(Sizes.p4)),
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
                Text('Quantity:'),
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
            SizedBox(
              height: Sizes.p64,
              child: ElevatedButton(
                onPressed: () => print('pressed'),
                child: Text(
                  'Add to Cart',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      // TODO: Do not hardcode
                      .copyWith(color: Colors.white),
                ),
              ),
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
