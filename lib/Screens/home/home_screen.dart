import 'package:flutter/material.dart';
import 'package:money_managment_app/Screens/add_transactions/screen_add_transaction.dart';
import 'package:money_managment_app/Screens/category/screen_category.dart';
import 'package:money_managment_app/Screens/home/widgets/bottom_navigation_bar.dart';
import 'package:money_managment_app/Screens/transactions/screen_transactions.dart';

import '../category/category_add_pop.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final _pages = const [
    ScreenTrancaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: Icon(Icons.account_balance_wallet, color: Colors.white),
        backgroundColor: Colors.pink,
        title: const Text(
          "Money Management",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: ScreenHome.selectedIndex,
          builder: (BuildContext ctx, int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndex.value == 0) {
            Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
          } else {
            CategoryAddPopup(context);
          }
        },
        backgroundColor: Colors.pink[300],
        child: Icon(Icons.add),
        hoverColor: Colors.pink[100],
        foregroundColor: Colors.white,
      ),
    );
  }
}
