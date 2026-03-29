// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Core/Common/cart_order_count.dart';
import 'package:farmers_1/Core/Common/payment_method_list.dart';
import 'package:farmers_1/Core/Model/model.dart';
import 'package:farmers_1/Core/Common/Utils/colors.dart';
import 'package:farmers_1/Core/Provider/cart_provider.dart';
import 'package:farmers_1/Core/Provider/favorite_provider.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/Items_detail_screen/Controller/place_order_controller.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/Items_detail_screen/Widgets/size_and_color.dart';
import 'package:farmers_1/Widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../User Activity/Add to Cart/Screen/cart_screen.dart';

class ItemsDetailScreen extends ConsumerStatefulWidget {
  final DocumentSnapshot<Object?> productItems;
  const ItemsDetailScreen({super.key, required this.productItems});

  @override
  ConsumerState<ItemsDetailScreen> createState() => _ItemsDetailScreenState();
}

class _ItemsDetailScreenState extends ConsumerState<ItemsDetailScreen> {
  int currentIndex = 0;
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  String? selectedPaymentMethodId;
  double? selectedPaymentBalance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CartProvider cp = ref.watch(cartService);
    FavoriteProvider provider = ref.watch(favouriteProvider);

    final finalPrice = num.parse(
      (widget.productItems['price'] *
              (1 - widget.productItems['discountPercentage'] / 100))
          .toStringAsFixed(2),
    );

    final List colors = widget.productItems['fcolor'] ?? [];
    final List sizes = widget.productItems['size'] ?? [];

    final selectedColor = colors.isNotEmpty
        ? colors[selectedColorIndex.clamp(0, colors.length - 1)]
        : null;
    final selectedSize = sizes.isNotEmpty
        ? sizes[selectedSizeIndex.clamp(0, sizes.length - 1)]
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: fbackgroundColor2,
        title: const Text("Detail Product"),
        actions: const [CartOrderCount(), SizedBox(width: 20)],
      ),

      // Scrollable Body
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              color: fbackgroundColor2,
              height: size.height * 0.46,
              width: size.width,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Hero(
                        tag: widget.productItems.id,
                        child: CachedNetworkImage(
                          imageUrl: widget.productItems['image'],
                          height: size.height * 0.4,
                          width: size.width * 0.85,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 4),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: i == currentIndex
                                  ? Colors.blue
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seller, rating, favorite
                  Row(
                    children: [
                      const Text(
                        "FARMERS MARKET",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.star, color: Colors.amber, size: 17),
                      Text(
                        "${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}",
                      ),
                      Text("(${Random().nextInt(300) + 55})"),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          provider.toggleFavorite(widget.productItems);
                        },
                        child: Icon(
                          provider.isExist(widget.productItems)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: provider.isExist(widget.productItems)
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // Product name
                  Text(
                    widget.productItems['name'],
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  // Price
                  Row(
                    children: [
                      Text(
                        "\R$finalPrice",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.pink,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (widget.productItems['isDiscounted'] == true)
                        Text(
                          "\R${widget.productItems['price']}.00",
                          style: const TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Text(
                    "$myDescription1 ${widget.productItems['name']}$myDescription2",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                      letterSpacing: -.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Size & Color Section
                  SizeAndColor(
                    colors: colors,
                    sizes: sizes,
                    selectedColorIndex: selectedColorIndex,
                    selectedSizeIndex: selectedSizeIndex,
                    onColorSelected: (index) {
                      setState(() => selectedColorIndex = index);
                    },
                    onSizeSelected: (index) {
                      setState(() => selectedSizeIndex = index);
                    },
                  ),

                  const SizedBox(height: 120), // bottom spacing before buttons
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            // ADD TO CART
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (selectedColor == null || selectedSize == null) return;
                  final productId = widget.productItems.id;
                  final productData =
                      widget.productItems.data() as Map<String, dynamic>;

                  cp.addCart(
                    productId,
                    productData,
                    selectedColor,
                    selectedSize,
                  );
                  showSnackBar(
                    context,
                    "${productData['name']} added to cart!",
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.4),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.shopping_bag, color: Colors.black),
                      SizedBox(width: 6),
                      Text(
                        "ADD TO CART",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // BUY NOW
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (selectedColor == null || selectedSize == null) return;
                  final productId = widget.productItems.id;
                  final productData =
                      widget.productItems.data() as Map<String, dynamic>;

                  _showOrderConfirmationDialog(
                    cp,
                    context,
                    productId,
                    productData,
                    selectedColor,
                    selectedSize,
                    finalPrice + 4.99,
                  );
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "BUY NOW",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderConfirmationDialog(
    CartProvider cp,
    BuildContext context,
    String productId,
    Map<String, dynamic> productData,
    String selectedColor,
    String selectedSize,
    double finalPrice,
  ) {
    String? addressError;
    TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Confirm Your Order"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Name: ${productData['name']}"),
                    const Text("Quantity: 1"),
                    Text("Selected Color: $selectedColor"),
                    Text("Selected Size: $selectedSize"),
                    Text("Total Price: \R$finalPrice"),
                    const SizedBox(height: 10),
                    const Text(
                      "Select Payment Method",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodList(
                      selectedPaymentMethodId: selectedPaymentMethodId,
                      selectedPaymentBalance: selectedPaymentBalance,
                      finalAmount: finalPrice,
                      onPaymentMethodSelected: (id, balance) {
                        setDialogState(() {
                          selectedPaymentMethodId = id;
                          selectedPaymentBalance = balance;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Add your Delivery Address",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: "Enter your address",
                        errorText: addressError,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (selectedPaymentMethodId == null) {
                              showSnackBar(
                                context,
                                "Please select a payment method!",
                              );
                            } else if (selectedPaymentBalance != null &&
                                selectedPaymentBalance! < finalPrice) {
                              showSnackBar(context, "Insufficient balance!");
                            } else if (addressController.text.length < 8) {
                              setDialogState(() {
                                addressError = "Your address is too short";
                              });
                            } else {
                              placeOrder(
                                productId,
                                productData,
                                selectedColor,
                                selectedSize,
                                selectedPaymentMethodId!,
                                finalPrice,
                                addressController.text,
                                context,
                              );
                            }
                          },
                          child: const Text("Confirm"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
