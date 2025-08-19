import 'package:chips_choice/chips_choice.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:cashier/commons/colors.dart';
import 'package:cashier/commons/currency.dart';
import 'package:cashier/commons/lists.dart';
import 'package:cashier/commons/sizes.dart';
import 'package:cashier/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartController _cartController = Get.find<CartController>();
  // Suggested payment options
  List<int> suggestions = [];

  void generateSuggestions() {
    final total = _cartController.totalBayar.value;
    suggestions.clear();

    // Index 0: closest multiple of 5000 (rounded up)
    int closest5000 = ((total + 4999) ~/ 5000) * 5000;
    suggestions.add(closest5000);

    // Index > 0: next multiples of 50000 (rounded up)
    int closest50000 = ((total + 49999) ~/ 50000) * 50000;

    // If closest5000 == closest50000, skip adding closest50000 again
    if (closest5000 != closest50000) {
      suggestions.add(closest50000);
      suggestions.add(closest50000 + 50000);
    } else {
      suggestions.add(closest50000 + 50000);
      suggestions.add(closest50000 + 100000);
    }
  }

  void updateInput(int value) {
    setState(() {
      _cartController.bayarTunai.text = CurrencyFormat.convertToIdr(
        _cartController.totalBayar.value,
        0,
      );
      _cartController.bayarTunai.text = CurrencyFormat.convertToIdr(value, 0);
    });
  }

  @override
  void initState() {
    super.initState();
    generateSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade50, // Set your desired background color here
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [MyColors.primary, MyColors.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -100,
                    left: -50,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: -60,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 70,
                    right: -40,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: MyColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  const Positioned(
                    top: 60,
                    left: 80,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form Pemesanan',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _cartController.cartList.length,
                              itemBuilder: (context, index) {
                                final cart = _cartController.cartList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: MyColors.notionBgGrey,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 12.0,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cart
                                                      .productModel
                                                      .productName!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MySizes.fontSizeMd,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${CurrencyFormat.convertToIdr(cart.productModel.price!, 0)}  x${cart.quantity}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        MySizes.fontSizeMd,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              CurrencyFormat.convertToIdr(
                                                cart.productModel.price! *
                                                    cart.quantity,
                                                0,
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: MySizes.fontSizeMd,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle_rounded,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () {
                                                _cartController.removeProduct(
                                                  cart.productModel,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          DividerLine(),
                          const Gap(10),
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Subtotal",
                                        style: TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: Text(
                                          CurrencyFormat.convertToIdr(
                                            _cartController.subTotal.value,
                                            0,
                                          ),
                                          style: const TextStyle(
                                            fontSize: MySizes.fontSizeMd,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Discount",
                                        style: TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          inputFormatters: [
                                            CurrencyTextInputFormatter.currency(
                                              locale: 'id',
                                              decimalDigits: 0,
                                              symbol: '',
                                            ),
                                          ],
                                          keyboardType: TextInputType.number,
                                          controller:
                                              _cartController
                                                  .discountController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 0.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 0.0,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            isDense: true,
                                          ),
                                          onChanged: (value) {
                                            final numericValue =
                                                int.tryParse(
                                                  value.replaceAll(
                                                    RegExp('[^0-9]'),
                                                    '',
                                                  ),
                                                ) ??
                                                0;
                                            final maxDiscount =
                                                _cartController.subTotal.value;
                                            if (numericValue > maxDiscount) {
                                              _cartController
                                                      .discountController
                                                      .text =
                                                  CurrencyFormat.convertToIdr(
                                                    maxDiscount,
                                                    0,
                                                  );
                                              _cartController
                                                      .discountController
                                                      .selection =
                                                  TextSelection.fromPosition(
                                                    TextPosition(
                                                      offset:
                                                          _cartController
                                                              .discountController
                                                              .text
                                                              .length,
                                                    ),
                                                  );
                                            }
                                            _cartController.applyDiscount();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  DividerLine(),
                                  const Gap(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total (${_cartController.totalAllQuantity.value} items)",
                                        style: const TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormat.convertToIdr(
                                          _cartController.totalBayar.value,
                                          0,
                                        ),
                                        style: const TextStyle(
                                          fontSize: MySizes.fontSizeXl,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Gap(10),
                          Obx(
                            () => ChipsChoice.single(
                              wrapped: true,
                              padding: EdgeInsets.zero,
                              value: _cartController.paymentMethod.value,
                              onChanged:
                                  (val) =>
                                      _cartController.paymentMethod.value = val,
                              choiceItems: C2Choice.listFrom<
                                String,
                                Map<String, dynamic>
                              >(
                                source: paymentCategory,
                                value: (i, v) => v['value'] as String,
                                label: (i, v) => v['nama'] as String,
                              ),
                              choiceStyle: C2ChipStyle.filled(
                                borderRadius: BorderRadius.circular(10),
                                color: MyColors.notionBgGrey,
                                selectedStyle: const C2ChipStyle(
                                  backgroundColor: Colors.redAccent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Pembayaran (Bayar Tunai)
                          Obx(() {
                            // Show Bayar Tunai & Kembalian only if payment method is 'cash'
                            if (_cartController.paymentMethod.value == 'Cash') {
                              return Column(
                                children: [
                                  const Gap(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Bayar Tunai",
                                        style: TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          inputFormatters: [
                                            CurrencyTextInputFormatter.currency(
                                              locale: 'id',
                                              decimalDigits: 0,
                                              symbol: '',
                                            ),
                                          ],
                                          keyboardType: TextInputType.number,
                                          controller:
                                              _cartController.bayarTunai,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 0.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 0.0,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                            isDense: true,
                                          ),
                                          onFieldSubmitted: (value) {
                                            final numericValue =
                                                int.tryParse(
                                                  value.replaceAll(
                                                    RegExp('[^0-9]'),
                                                    '',
                                                  ),
                                                ) ??
                                                0;
                                            final maxBayarTunai =
                                                _cartController
                                                    .totalBayar
                                                    .value;
                                            if (numericValue < maxBayarTunai) {
                                              _cartController.bayarTunai.text =
                                                  CurrencyFormat.convertToIdr(
                                                    maxBayarTunai,
                                                    0,
                                                  );
                                              _cartController
                                                      .bayarTunai
                                                      .selection =
                                                  TextSelection.fromPosition(
                                                    TextPosition(
                                                      offset:
                                                          _cartController
                                                              .bayarTunai
                                                              .text
                                                              .length,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  ChipsChoice.single(
                                    wrapped: false,
                                    value: suggestions.indexWhere(
                                      (amount) =>
                                          CurrencyFormat.convertToIdr(
                                            amount,
                                            0,
                                          ) ==
                                          _cartController.bayarTunai.text,
                                    ),
                                    onChanged: (index) {
                                      if (index == -1) {
                                        updateInput(
                                          _cartController.totalBayar.value,
                                        );
                                      } else if (index >= 0 &&
                                          index < suggestions.length) {
                                        updateInput(suggestions[index]);
                                      }
                                    },
                                    choiceItems: [
                                      const C2Choice(
                                        value: -1,
                                        label: "Uang Pas",
                                      ),
                                      ...suggestions.asMap().entries.map(
                                        (entry) => C2Choice(
                                          value: entry.key,
                                          label: CurrencyFormat.convertToIdr(
                                            entry.value,
                                            0,
                                          ),
                                        ),
                                      ),
                                    ],
                                    choiceStyle: C2ChipStyle.filled(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MyColors.notionBgGrey,
                                      selectedStyle: const C2ChipStyle(
                                        backgroundColor: Colors.green,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  // Kembalian
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Kembalian",
                                        style: TextStyle(
                                          fontSize: MySizes.fontSizeMd,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Obx(() {
                                        final bayarText =
                                            _cartController.bayarTunai.text;
                                        final bayar =
                                            bayarText.isNotEmpty
                                                ? int.tryParse(
                                                      bayarText.replaceAll(
                                                        RegExp('[^0-9]'),
                                                        '',
                                                      ),
                                                    ) ??
                                                    0
                                                : 0;
                                        final totalBayar =
                                            _cartController.totalBayar.value;
                                        final kembalian = bayar - totalBayar;
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: Text(
                                            CurrencyFormat.convertToIdr(
                                              kembalian > 0 ? kembalian : 0,
                                              0,
                                            ),
                                            style: const TextStyle(
                                              fontSize: MySizes.fontSizeMd,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                          const Gap(30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_cartController.isButtonDisabled.value) {
                                  return;
                                }
                                _cartController.saveCart();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _cartController.isButtonDisabled.value
                                        ? Colors.grey
                                        : MyColors.primary, // Button color
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                'Proses Pemesanan',
                                style: TextStyle(
                                  fontSize: MySizes.fontSizeMd,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Divider DividerLine() => Divider(color: Colors.grey.shade300);
}
