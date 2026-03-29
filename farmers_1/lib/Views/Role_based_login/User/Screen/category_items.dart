import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Core/Model/sub_category.dart';
import 'package:farmers_1/Core/Common/Utils/colors.dart';
import 'package:farmers_1/Core/Provider/favorite_provider.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/Items_detail_screen/Screen/items_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CategoryItems extends ConsumerStatefulWidget {
  final String selectedCategory;
  final String category;
  const CategoryItems({
    super.key,
    required this.category,
    required this.selectedCategory,
  });

  @override
  ConsumerState<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends ConsumerState<CategoryItems> {
  Map<String, Map<String, dynamic>> randomValueCache = {};
  TextEditingController searchController = TextEditingController();
  List<QueryDocumentSnapshot> allItems = [];
  List<QueryDocumentSnapshot> filteredItems = [];

  @override
  void initState() {
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchTerm = searchController.text.toLowerCase();
    setState(() {
      filteredItems = allItems.where((item) {
        final data = item.data() as Map<String, dynamic>;
        final itemName = data['name'].toString().toLowerCase();
        return itemName.contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference itemsCollection = FirebaseFirestore.instance
        .collection("items");
    final provider = ref.watch(favouriteProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          hintText: "${widget.category}'s Fashion",
                          hintStyle: const TextStyle(color: Colors.black38),
                          filled: true,
                          fillColor: fbackgroundColor2,
                          prefixIcon: const Icon(
                            Iconsax.search_normal,
                            color: Colors.black38,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Filter categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filterCategory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              filterCategory[index],
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              index == 0
                                  ? Icons.filter_list
                                  : Icons.keyboard_arrow_down,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subcategories
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: subcategory.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: fbackgroundColor1,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(subcategory[index].image),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subcategory[index].name,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Grid of items
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: itemsCollection
                    .where('category', isEqualTo: widget.selectedCategory)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final items = snapshot.data!.docs;
                    if (allItems.isEmpty) {
                      allItems = items;
                      filteredItems = items;
                    }
                    if (filteredItems.isEmpty) {
                      return const Center(child: Text("No items found."));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.70,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final doc = filteredItems[index];
                        final item = doc.data() as Map<String, dynamic>;
                        final itemId = doc.id;

                        if (!randomValueCache.containsKey(itemId)) {
                          randomValueCache[itemId] = {
                            "rating":
                                "${Random().nextInt(2) + 3}.${Random().nextInt(5) + 4}",
                            "reviews": Random().nextInt(300) + 100,
                          };
                        }

                        final cachedRating =
                            randomValueCache[itemId]!['rating'];
                        final cachedReviews =
                            randomValueCache[itemId]!['reviews'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ItemsDetailScreen(productItems: doc),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image section
                                Expanded(
                                  flex: 5,
                                  child: Hero(
                                    tag: doc.id,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: fbackgroundColor2,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                            item['image'],
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                provider.isExist(items[index])
                                                ? Colors.white
                                                : Colors.black26,
                                            child: GestureDetector(
                                              onTap: () {
                                                ref
                                                    .read(favouriteProvider)
                                                    .toggleFavorite(
                                                      items[index],
                                                    );
                                              },
                                              child: Icon(
                                                provider.isExist(items[index])
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 16,
                                                color:
                                                    provider.isExist(
                                                      items[index],
                                                    )
                                                    ? Colors.red
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Content section
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Title and rating row
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "FARMERS MARKET",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 12,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              "$cachedRating",
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                            Text(
                                              "($cachedReviews)",
                                              style: const TextStyle(
                                                color: Colors.black38,
                                                fontSize: 9,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Product name
                                        Text(
                                          item['name'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),

                                        // Price row
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "\R${(item['price'] * (1 - item['discountPercentage'] / 100)).toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: Colors.pink,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            if (item['isDiscounted'] == true)
                                              Flexible(
                                                child: Text(
                                                  "\R${item['price']}.00",
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                      255,
                                                      128,
                                                      122,
                                                      122,
                                                    ),
                                                    fontSize: 11,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationColor:
                                                        Colors.black26,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
