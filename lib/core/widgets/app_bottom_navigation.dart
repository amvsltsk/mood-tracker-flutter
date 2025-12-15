import 'package:flutter/material.dart';
import 'package:mood_diary_app/screens/settings_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/history_screen.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF7FAFC),
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color(0xFF4D7399),
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Statistics"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
            break;
          case 1:
            if (currentIndex != 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            }
            break;
          case 2:
          // TODO: Статистика
            break;
          case 3:
            if (currentIndex != 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }
            break;
        }
      },
    );
  }
}
