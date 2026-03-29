import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Widgets/my_button.dart';
import 'package:farmers_1/Widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: "**** **** **** ****",
    filter: {"*": RegExp(r'[0-9]')},
  );

  double balance = 0.0;
  String? selectedPaymentSystem;
  Map<String, dynamic>? selectedPaymentSystemData;
  final _formKey = GlobalKey<FormState>();

  Future<List<Map<String, dynamic>>> fetchPaymentSystems() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("payment_methods")
        .get();
    return snapshot.docs
        .map((doc) => {'name': doc['name'], 'image': doc['image']})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: const Text(
          "Add Payment Method",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            shadowColor: Colors.green.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchPaymentSystems(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("No payment systems available");
                        }
                        return DropdownButtonFormField<String>(
                          value: selectedPaymentSystem,
                          hint: const Text("Select Payment System"),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: snapshot.data!.map((system) {
                            return DropdownMenuItem<String>(
                              value: system['name'],
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: system['image'],
                                    width: 30,
                                    height: 30,
                                    errorWidget: (context, stackTrace, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(system['name']),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPaymentSystem = value;
                              selectedPaymentSystemData = snapshot.data!
                                  .firstWhere(
                                    (system) => system['name'] == value,
                                  );
                            });
                          },
                          validator: (value) => value == null
                              ? "Please select a payment system"
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _userNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Card Holder Name",
                        labelStyle: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: "e.g. John Doe",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.green[600]!,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return "Provide your full name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [maskFormatter],
                      decoration: InputDecoration(
                        labelText: "Card Number",
                        labelStyle: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        hintText: "e.g. 1234 5678 9012 3456",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.green[600]!,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.replaceAll(' ', '').length != 16) {
                          return "Card number must be exactly 16 digits";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Balance",
                        labelStyle: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixText: "R ",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.green[600]!,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) =>
                          balance = double.tryParse(value) ?? 0.0,
                    ),
                    const SizedBox(height: 25),
                    MyButton(
                      onTab: () => addPaymentMethod(),
                      buttonText: "Add Payment Method",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addPaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null && selectedPaymentSystemData != null) {
      final paymentCollection = FirebaseFirestore.instance.collection(
        "User Payment Method",
      );

      final existingMethods = await paymentCollection
          .where('userId', isEqualTo: userId)
          .where("paymentSystem", isEqualTo: selectedPaymentSystemData!['name'])
          .get();

      if (existingMethods.docs.isNotEmpty) {
        showSnackBar(context, "You have already added this payment method!");
        return;
      }

      await paymentCollection.add({
        'userName': _userNameController.text.trim(),
        'cardNumber': _cardNumberController.text.trim(),
        'balance': balance,
        'userId': userId,
        'paymentSystem': selectedPaymentSystemData!['name'],
        'image': selectedPaymentSystemData!['image'],
      });

      showSnackBar(context, "Payment method successfully added!");
      Navigator.pop(context);
    } else {
      showSnackBar(context, "Failed to add payment method. Please try again.");
    }
  }
}
