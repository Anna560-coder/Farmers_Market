import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Core/Provider/Model/cart_model.dart';
import 'package:farmers_1/Widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartService = ChangeNotifierProvider<CartProvider>((ref) {
  return CartProvider();
});

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CartProvider() {
    loadCartItems();
  }

  void reset() {
    _carts = [];
    notifyListeners();
  }

  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }

  Future<void> addCart(
    String productId,
    Map<String, dynamic> productData,
    String selectedColor,
    String selectedSize,
  ) async {
    if (userId == null) return;
    int index = _carts.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      var existingItem = _carts[index];
      _carts[index] = CartModel(
        productId: existingItem.productId,
        productData: existingItem.productData,
        quantity: existingItem.quantity + 1,
        selectedColor: selectedColor,
        selectedSize: selectedSize,
      );

      await _updateCartInFirebase(productId, _carts[index].quantity);
    } else {
      _carts.add(
        CartModel(
          productId: productId,
          productData: productData,
          quantity: 1,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ),
      );

      await _firestore
          .collection('userCart')
          .doc(userId)
          .collection('cartItems')
          .doc(productId)
          .set({
            'productData': productData,
            'quantity': 1,
            'selectedColor': selectedColor,
            'selectedSize': selectedSize,
          });
    }
    notifyListeners();
  }

  Future<void> addQuantity(String productId) async {
    if (userId == null) return;

    int index = _carts.indexWhere((element) => element.productId == productId);
    _carts[index].quantity += 1;
    await _updateCartInFirebase(productId, _carts[index].quantity);
    notifyListeners();
  }

  Future<void> reduceQuantity(String productId) async {
    if (userId == null) return;

    int index = _carts.indexWhere((element) => element.productId == productId);
    _carts[index].quantity -= 1;
    if (_carts[index].quantity <= 0) {
      _carts.removeAt(index);
      await _firestore
          .collection('userCart')
          .doc(userId)
          .collection('cartItems')
          .doc(productId)
          .delete();
    } else {
      await _updateCartInFirebase(productId, _carts[index].quantity);
    }
    notifyListeners();
  }

  bool productExist(String productId) {
    return _carts.any((element) => element.productId == productId);
  }

  double totalCart() {
    double total = 0;
    for (var i = 0; i < _carts.length; i++) {
      final finalPrice = num.parse(
        (_carts[i].productData['price'] *
                (1 - _carts[i].productData['discountPercentage'] / 100))
            .toStringAsFixed(2),
      );
      total += _carts[i].quantity * finalPrice;
    }
    return total;
  }

  Future<void> loadCartItems() async {
    if (userId == null) return;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('userCart')
          .doc(userId)
          .collection('cartItems')
          .get();

      _carts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return CartModel(
          productId: doc.id,
          productData: data['productData'],
          quantity: data['quantity'],
          selectedColor: data['selectedColor'],
          selectedSize: data['selectedSize'],
        );
      }).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> saveOrder(
    String userId,
    BuildContext context,
    paymentMethodId,
    finalPrice,
    address,
  ) async {
    if (_carts.isEmpty) {
      return; // Ensure user is authenticated and cart is not empty
    }

    final paymentRef = _firestore
        .collection('User Payment Method')
        .doc(paymentMethodId);

    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(paymentRef);
        if (!snapshot.exists) throw Exception('Payment method not found');

        final currentBalance = snapshot['balance'] as num;
        if (currentBalance < finalPrice) throw Exception('Insufficient funds');

        // Deduct balance
        transaction.update(paymentRef, {
          'balance': currentBalance - finalPrice,
        });

        // Create order data
        final orderData = {
          'userId': userId,
          'items': _carts.map((cartItem) {
            return {
              'productId': cartItem.productId,
              'quantity': cartItem.quantity,
              'selectedColor': cartItem.selectedColor,
              'selectedSize': cartItem.selectedSize,
              'name': cartItem.productData['name'],
              'price': cartItem.productData['price'],
            };
          }).toList(),
          'totalPrice': finalPrice,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'address': address,
        };

        final ordersRef = _firestore.collection('Orders').doc();
        transaction.set(ordersRef, orderData);
      });

      showSnackBar(context, "Order placed successfully!");
    } on FirebaseException catch (e) {
      showSnackBar(context, "Firebase error: ${e.message}");
    } on Exception catch (e) {
      showSnackBar(context, "Error: ${e.toString()}");
    }
  }

  // Remove cart item from Firestore
  Future<void> deleteCartItem(String productId) async {
    if (userId == null) return;

    int index = _carts.indexWhere((element) => element.productId == productId);
    if (index != -1) {
      _carts.removeAt(index);
      await _firestore
          .collection('userCart')
          .doc(userId)
          .collection('cartItems')
          .doc(productId)
          .delete();
      notifyListeners();
    }
  }

  // Update cart item in Firebase
  Future<void> _updateCartInFirebase(String productId, int quantity) async {
    if (userId == null) return;

    try {
      await _firestore
          .collection('userCart')
          .doc(userId)
          .collection('cartItems')
          .doc(productId)
          .update({'quantity': quantity});
    } catch (e) {
      print(e.toString());
    }
  }
}
