// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Core/Provider/cart_provider.dart';
import 'package:farmers_1/Core/Provider/favorite_provider.dart';
import 'package:farmers_1/Services/auth_service.dart';
import 'package:farmers_1/Views/Role_based_login/Admin/Admin_notification/AdminNotificationScreen.dart';
import 'package:farmers_1/Views/Role_based_login/Admin/Screen/add_items.dart';
import 'package:farmers_1/Views/Role_based_login/Admin/Screen/order_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/chatbot/AI_pages_menu.dart';
import 'package:farmers_1/Views/Role_based_login/login_screen.dart';
import 'package:farmers_1/Widgets/show_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AuthService _authService = AuthService();

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );
  String? selectedCategory;
  List<String> categories = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("Category")
        .get();
    setState(() {
      categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        elevation: 4,
        shadowColor: Colors.greenAccent.withOpacity(0.3),
        title: const Text(
          "Your Uploaded Items",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          // Orders badge
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
            builder: (context, snapshot) {
              final orderCount = snapshot.data?.docs.length ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.receipt_long, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminOrderScreen(),
                        ),
                      );
                    },
                  ),
                  if (orderCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$orderCount",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _authService.signOut();
              ref.invalidate(cartService);
              ref.invalidate(favouriteProvider);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Category Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Filter by Category"),
                  value: selectedCategory,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.filter_list, color: Colors.green),
                  items: categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() => selectedCategory = newValue);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Items List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: selectedCategory == null
                      ? items.where("uploadedBy", isEqualTo: uid).snapshots()
                      : items
                            .where("uploadedBy", isEqualTo: uid)
                            .where('category', isEqualTo: selectedCategory)
                            .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Error loading items."));
                    }
                    final documents = snapshot.data?.docs ?? [];
                    if (documents.isEmpty) {
                      return const Center(
                        child: Text(
                          "No items uploaded.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final item =
                            documents[index].data() as Map<String, dynamic>;
                        return Card(
                          elevation: 4,
                          shadowColor: Colors.greenAccent.withOpacity(0.3),
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: item['image'],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              item['name'] ?? "N/A",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "R${item['price']}.00 • ${item['category'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.green,
                              ),
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => AddItems(),
                                    ),
                                  );
                                } else if (value == 'delete') {
                                  _confirmDeleteItem(documents[index].id);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text("Edit Item"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text("Delete Item"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      //Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green.shade700,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI"),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: "Add Item",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notifications",
            ),
          ],
          onTap: (index) async {
            setState(() => _selectedIndex = index);

            if (index == 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIPagesMenu()),
              );
            } else if (index == 1) {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItems()),
              );
            } else if (index == 2) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminNotificationScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _confirmDeleteItem(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await _deleteItem(itemId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      await items.doc(itemId).delete();
      showSnackBar(context, 'Item deleted successfully!');
    } catch (e) {
      showSnackBar(context, 'Error deleting item: $e');
    }
  }
}
