import 'package:flutter/material.dart';

import '../home_screen.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ScreenHome.selectedIndex,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            ScreenHome.selectedIndex.value = newIndex;
          },
          selectedItemColor: Colors.pink,
          // useLegacyColorScheme: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories')
          ],
        );
      },
    );
  }
}
