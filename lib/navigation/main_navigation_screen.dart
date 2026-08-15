import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/requests/requests_screen.dart';
import '../widgets/common/app_bottom_nav_bar.dart';
import '../widgets/common/placeholder_screen.dart';
import 'nav_item.dart';

/// Hosts the 5 bottom-nav tabs and keeps each tab's state alive with
/// IndexedStack
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const List<NavItem> _navItems = [
    NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    NavItem(
      icon: Icons.list_alt_outlined,
      activeIcon: Icons.list_alt,
      label: 'Requests',
    ),
    NavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Map'),
    NavItem(
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy,
      label: 'AI',
    ),
    NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  static final List<Widget> _screens = [
    HomeScreen(),
    RequestsScreen(),
    const PlaceholderScreen(
      title: 'Map',
      subtitle: 'Coming soon on the Map Flow branch',
    ),
    const PlaceholderScreen(
      title: 'AI Assistant',
      subtitle: 'Coming soon on the Chatbot Flow branch',
    ),
    const PlaceholderScreen(
      title: 'Profile',
      subtitle: 'Coming soon on the Profile Flow branch',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: AppBottomNavBar(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}