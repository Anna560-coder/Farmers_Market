import 'dart:io';
import 'package:farmers_1/Views/Role_based_login/Admin/Controller/add_items_controller.dart';
import 'package:farmers_1/Widgets/my_button.dart';
import 'package:farmers_1/Widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddItems extends ConsumerWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _discountpercentageController =
      TextEditingController();

  AddItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);

    // Listen for discount input changes
    _discountpercentageController.addListener(() {
      notifier.setDiscountPercentage(_discountpercentageController.text);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          "Add New Item",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Upload Product Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image picker
                Center(
                  child: GestureDetector(
                    onTap: notifier.pickImage,
                    child: Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F6EE),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green, width: 1.2),
                      ),
                      child: state.imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                File(state.imagePath!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(
                              child: state.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.green,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "Tap to add image",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                _buildTextField("Item Name", _nameController),
                const SizedBox(height: 15),
                _buildTextField(
                  "Price (R)",
                  _priceController,
                  keyboard: TextInputType.number,
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: state.selectedCategory,
                  decoration: _inputDecoration("Select Category"),
                  onChanged: notifier.setSelectedCategory,
                  items: state.categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),

                _buildTextField(
                  "Sizes (comma separated)",
                  _sizeController,
                  onSubmitted: (value) {
                    notifier.addSize(value);
                    _sizeController.clear();
                  },
                ),
                _buildChips(state.sizes, notifier.removeSize),
                const SizedBox(height: 15),

                _buildTextField(
                  "Colors (comma separated)",
                  _colorController,
                  onSubmitted: (value) {
                    notifier.addColor(value);
                    _colorController.clear();
                  },
                ),
                _buildChips(state.colors, notifier.removeColor),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.green,
                      value: state.isDiscounted,
                      onChanged: notifier.toggleDiscount,
                    ),
                    const Text(
                      "Apply Discount",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                if (state.isDiscounted) ...[
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Discount Percentage (%)",
                    _discountpercentageController,
                    keyboard: TextInputType.number,
                  ),
                ],

                const SizedBox(height: 30),

                state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      )
                    : Center(
                        child: MyButton(
                          onTab: () async {
                            try {
                              await notifier.uploadAndSaveItem(
                                _nameController.text,
                                _priceController.text,
                              );
                              showSnackBar(context, "Item added successfully!");
                              Navigator.of(context).pop();
                            } catch (e) {
                              showSnackBar(context, e.toString());
                            }
                          },
                          buttonText: "Save Item",
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.green),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 1.6),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      onSubmitted: onSubmitted,
      decoration: _inputDecoration(label),
    );
  }

  Widget _buildChips(List<String> items, Function(String) onDelete) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Wrap(
        spacing: 8,
        children: items
            .map(
              (item) => Chip(
                backgroundColor: const Color(0xFFE9F6EE),
                label: Text(item, style: const TextStyle(color: Colors.green)),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => onDelete(item),
              ),
            )
            .toList(),
      ),
    );
  }
}
