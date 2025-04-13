import 'package:esjerukkadiri/commons/colors.dart';
import 'package:esjerukkadiri/commons/currency.dart';
import 'package:esjerukkadiri/commons/sizes.dart';
import 'package:flutter/cupertino.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.dataPrice,
  });

  final int dataPrice;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Rp ',
            style: const TextStyle(
              color: MyColors.primary,
              fontSize: MySizes.fontSizeMd,
            ),
          ),
          TextSpan(
            text: CurrencyFormat.convertToIdr(dataPrice, 0),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MySizes.fontSizeXl,
              color: MyColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
