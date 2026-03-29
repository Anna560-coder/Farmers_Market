import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Core/Common/cart_order_count.dart';
import 'package:farmers_1/Core/Model/category_model.dart';
import 'package:farmers_1/Core/Common/Utils/colors.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/Items_detail_screen/Screen/items_detail_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/category_items.dart';
import 'package:farmers_1/Views/Role_based_login/User/Widgets/banner.dart';
import 'package:farmers_1/Views/Role_based_login/User/Widgets/curated_items.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// duplicate import removed
import 'package:farmers_1/Views/Role_based_login/User/Screen/Notifications/notificationScreen.dart';

class UserAppHomeScreen extends StatefulWidget {
  const UserAppHomeScreen({super.key});

  @override
  State<UserAppHomeScreen> createState() => _UserAppHomeScreenState();
}

class _UserAppHomeScreenState extends State<UserAppHomeScreen> {
  // for category collection
  final CollectionReference categoriesItems = FirebaseFirestore.instance
      .collection("Category");
  // for e-commerce items collection
  final CollectionReference items = FirebaseFirestore.instance.collection(
    "items",
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: Text("Welcome Farmers")),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // for header parts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/onboarding.png", height: 40),
                  Row(
                    children: [
                      // Unread notifications badge
                      _NotificationsBadge(),
                      const SizedBox(width: 12),

                      /// change the logo
                      CartOrderCount(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // for banner
            const MyBanner(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shop By Cayegory",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            // for category
            StreamBuilder(
              stream: categoriesItems.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        streamSnapshot.data!.docs.length,
                        (index) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryItems(
                                  selectedCategory:
                                      streamSnapshot.data!.docs[index]['name'],
                                  category:
                                      streamSnapshot.data!.docs[index]['name'],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: fbackgroundColor1,
                                  backgroundImage: AssetImage(
                                    category[index].image,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(category[index].name),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Curated For You",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            // for curated items
            StreamBuilder(
              stream: items.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(snapshot.data!.docs.length, (
                        index,
                      ) {
                        final eCommerceItems = snapshot.data!.docs[index];
                        return Padding(
                          padding: index == 0
                              ? const EdgeInsets.symmetric(horizontal: 20)
                              : const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItemsDetailScreen(
                                    productItems: eCommerceItems,
                                  ),
                                ),
                              );
                            },
                            child: CuratedItems(
                              eCommerceItems: eCommerceItems,
                              size: size,
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox();

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);
    final userNotifs = FirebaseFirestore.instance
        .collection('user_notifications')
        .doc(user.uid)
        .collection('notifications');
    final broadcasts = FirebaseFirestore.instance.collection(
      'broadcast_notifications',
    );

    return StreamBuilder<DocumentSnapshot>(
      stream: userDoc.snapshots(),
      builder: (context, userSnapshot) {
        final doc = userSnapshot.data;
        final Map<String, dynamic>? docData = doc == null
            ? null
            : (doc.data() as Map<String, dynamic>?);
        final dynamic raw = docData == null
            ? null
            : docData['notificationsLastOpened'];
        final lastOpened = raw is Timestamp ? raw.toDate() : null;
        return StreamBuilder<QuerySnapshot>(
          stream: userNotifs.snapshots(),
          builder: (context, userNotifsSnap) {
            return StreamBuilder<QuerySnapshot>(
              stream: broadcasts.snapshots(),
              builder: (context, broadcastsSnap) {
                if (!userNotifsSnap.hasData || !broadcastsSnap.hasData) {
                  return IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Notificationscreen(),
                        ),
                      );
                    },
                  );
                }

                int count = 0;
                for (final d in userNotifsSnap.data!.docs) {
                  final ts = (d['timestamp'] as Timestamp?)?.toDate();
                  if (lastOpened == null ||
                      (ts != null && ts.isAfter(lastOpened)))
                    count++;
                }
                for (final d in broadcastsSnap.data!.docs) {
                  final ts = (d['createdAt'] as Timestamp?)?.toDate();
                  if (lastOpened == null ||
                      (ts != null && ts.isAfter(lastOpened)))
                    count++;
                }

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Notificationscreen(),
                          ),
                        );
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
