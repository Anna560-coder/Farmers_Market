import 'package:farmers_1/Views/Role_based_login/User/Screen/user_app_home_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/Todo_List/real_time_database.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Activity/favorite_screen.dart';
import 'package:farmers_1/Views/Role_based_login/User/User%20Profile/user_profile.dart';
import 'package:farmers_1/Views/Role_based_login/User/chatbot/AI_pages_menu.dart';
import 'package:farmers_1/WeatherUpdates/WeatherSplashScreen.dart';
//import 'package:farmers_1/WeatherUpdates/WeatherSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:farmers_1/Core/Common/app_localizations_helper.dart';

class UserAppMainScreen extends StatefulWidget {
  const UserAppMainScreen({super.key});

  @override
  State<UserAppMainScreen> createState() => _UserAppMainScreenState();
}

class _UserAppMainScreenState extends State<UserAppMainScreen> {
  int selectedIndex = 0;
  final List pages = [
    const UserAppHomeScreen(),
    const FavoriteScreen(),
    const UserProfile(),
    const RealTimeDatabase(),
    const AIPagesMenu(),
    const Weathersplashscreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsHelper.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 0,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.heart),
            label: l10n.favorite,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: l10n.profile,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.task_alt),
            label: l10n.tasks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.support_agent),
            label: l10n.ai,
          ),
          BottomNavigationBarItem(
            icon: const Icon(WeatherIcons.day_sunny, size: 30),
            label: l10n.weatherUpdates,
          ),
        ],
      ),

      body: pages[selectedIndex],
    );
  }
}
