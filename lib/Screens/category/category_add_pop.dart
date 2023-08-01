import 'package:flutter/material.dart';
import 'package:money_managment_app/db/category/category_db.dart';
import 'package:money_managment_app/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> CategoryAddPopup(BuildContext context) async {
  final _nameController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text("Add Category"),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: 'Category name', border: OutlineInputBorder()),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                RadioButton(title: "Income", type: CategoryType.income),
                RadioButton(title: "Expense", type: CategoryType.expense),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameController.text;
                if (_name.isEmpty) {
                  return;
                }
                final _category = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _name,
                  type: selectedCategoryNotifier.value,
                );
                CategoryDB.instance.insertCategory(_category);
                Navigator.of(ctx).pop();
              },
              child: const Text('add'),
            ),
          ),
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  const RadioButton({super.key, required this.title, required this.type});

  final String title;
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        // left: 20.0,
        right: 20,
      ),
      child: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                  selectedCategoryNotifier.notifyListeners();
                },
              );
            },
          ),
          Text(title),
        ],
      ),
    );
  }
}
