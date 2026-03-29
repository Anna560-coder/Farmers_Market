import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmers_1/Core/Provider/cart_provider.dart';
import 'package:farmers_1/Core/Provider/favorite_provider.dart';
import 'package:farmers_1/Core/Provider/language_provider.dart';
import 'package:farmers_1/Services/auth_service.dart';
import 'package:farmers_1/Views/Role_based_login/User/Screen/Notifications/notificationScreen.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Profile/About_Screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Profile/Order/my_order_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Profile/Payment/payment_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Profile/farm_profile_screen.dart';
import 'package:farmers_1/Views/Role_based_login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmers_1/Core/Common/app_localizations_helper.dart';

AuthService _authService = AuthService();

class UserProfile extends ConsumerWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final l10n = AppLocalizationsHelper.of(context);
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // current login user details
                SizedBox(
                  width: double.maxFinite,
                  // fetch the the user data from firebase
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final user = snapshot.data!;
                      return Column(
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundImage: CachedNetworkImageProvider(
                              "https://www.pngarts.com/files/5/User-Avatar-Free-PNG-Image.png",
                            ),
                          ),
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              height: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user['email'],
                            style: const TextStyle(height: 0.5),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                Column(
                  children: [
                    // Language Selection
                    GestureDetector(
                      onTap: () {
                        _showLanguageDialog(context, ref);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.language, size: 30),
                        title: Text(
                          l10n.language,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Text(
                          currentLanguage.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    // farm profile
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FarmProfileScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.person, size: 30),
                        title: Text(
                          "Farm profile",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyOrderScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.change_circle_rounded,
                          size: 30,
                        ),
                        title: Text(
                          l10n.order,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentScreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.payments, size: 30),
                        title: Text(
                          l10n.paymentMethod,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    //notification
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Notificationscreen(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.notifications, size: 30),
                        title: Text(
                          l10n.notifications,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // About us
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutUsPage(),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: const Icon(Icons.info, size: 30),
                        title: Text(
                          l10n.aboutUs,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    //log out
                    GestureDetector(
                      onTap: () {
                        _authService.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                        ref.invalidate(cartService);
                        ref.invalidate(favouriteProvider);
                      },
                      child: ListTile(
                        leading: const Icon(Icons.exit_to_app, size: 30),
                        title: Text(
                          l10n.logOut,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizationsHelper.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((language) {
              return RadioListTile<AppLanguage>(
                title: Text(language.displayName),
                value: language,
                groupValue: ref.read(languageProvider),
                onChanged: (AppLanguage? value) {
                  if (value != null) {
                    ref.read(languageProvider.notifier).setLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
