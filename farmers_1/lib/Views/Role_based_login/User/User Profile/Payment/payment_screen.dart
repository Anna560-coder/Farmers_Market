import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Profile/Payment/add_payment.dart';
import 'package:farmers_1/Widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser?.uid; // get user id
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: const Text(
          "Payment Methods",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: userId == null
          ? const Center(
              child: Text(
                "Please login to view payment methods.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Payment Method")
                  .where("userId", isEqualTo: userId)
                  .snapshots(), // filter by userid
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final methods = snapshot.data!.docs;

                if (methods.isEmpty) {
                  return const Center(
                    child: Text(
                      "No payment methods found. Please add a payment method.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: methods.length,
                  itemBuilder: (context, index) {
                    final method = methods[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      shadowColor: Colors.green.withOpacity(0.3),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CachedNetworkImage(
                          imageUrl: method['image'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          method['paymentSystem'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: const Text(
                          "Activate",
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _showAddFundsDialog(context, method),
                          child: const Text(
                            "Add Fund",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 3,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPaymentMethod()),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  void _showAddFundsDialog(BuildContext context, DocumentSnapshot method) {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Add Amount",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            filled: true,
            //fillColor: Colors.white38,
            fillColor: Colors.grey.shade200,
            labelText: "Amount",
            labelStyle: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
            prefixText: "R ",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[600]!, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                showSnackBar(context, "Please enter a valid positive amount");
                return;
              }
              try {
                await method.reference.update({
                  'balance': FieldValue.increment(amount),
                });
                Navigator.pop(context);
                showSnackBar(context, "Fund Added Successfully!");
              } catch (e) {
                showSnackBar(context, "Error adding funds: $e");
              }
            },
            child: const Text("Add", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}
