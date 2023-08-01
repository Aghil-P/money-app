import 'package:flutter/material.dart';
import 'package:money_managment_app/Screens/category/expense_category.dart';
import 'package:money_managment_app/Screens/category/income_category.dart';
import 'package:money_managment_app/db/category/category_db.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    CategoryDB().refreshUI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(controller: _tabController, tabs: [
          Tab(
            text: 'Income',
          ),
          Tab(
            text: 'Expense',
          ),
        ]),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            IncomeCategory(),
            ExpenseCategory(),
          ]),
        )
      ],
    );
  }
}
