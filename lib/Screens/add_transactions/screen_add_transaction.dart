import 'package:flutter/material.dart';
import 'package:money_managment_app/db/category/category_db.dart';
import 'package:money_managment_app/db/transactions/transaction_db.dart';
import 'package:money_managment_app/models/category/category_model.dart';
import 'package:money_managment_app/models/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  const ScreenAddTransaction({super.key});

  static const routeName = 'add_transaction';

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _selectedCategoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: const Icon(Icons.account_balance_wallet, color: Colors.white),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _purposeTextEditingController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: "Purpose",
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pinkAccent))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pinkAccent),
                  ),
                  hintText: "Amount",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: CategoryType.income,
                    groupValue: _selectedCategoryType,
                    onChanged: (newType) {
                      setState(() {
                        _selectedCategoryType = CategoryType.income;
                        _selectedCategoryID = null;
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Text("Income"),
                  ),
                  Radio(
                    value: CategoryType.expense,
                    groupValue: _selectedCategoryType,
                    onChanged: (newType) {
                      setState(() {
                        _selectedCategoryType = CategoryType.expense;
                        _selectedCategoryID = null;
                      });
                    },
                  ),
                  const Text("Expense"),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButton(
                hint: const Text('Select Category'),
                value: _selectedCategoryID,
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB().incomeCategoryListListener
                        : CategoryDB().expenseCategoryListListener)
                    .value
                    .map(
                  (e) {
                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                      onTap: () {
                        _selectedCategoryModel = e;
                      },
                    );
                  },
                ).toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    _selectedCategoryID = selectedValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton.icon(
                  onPressed: () async {
                    final selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDateTemp == null) {
                      return;
                    } else {
                      setState(() {
                        _selectedDate = selectedDateTemp;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null
                      ? 'Select date'
                      : _selectedDate.toString().trim()),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final purpose = _purposeTextEditingController.text;
    final amount = _amountTextEditingController.text;
    if (purpose.isEmpty) {
      return;
    }
    if (amount.isEmpty) {
      return;
    }
    if (_selectedCategoryType == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    final amountParsed = double.tryParse(amount);
    if (amountParsed == null) {
      return;
    }
    final newModel = TransactionModel(
      purpose: purpose,
      amount: amountParsed,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
      date: _selectedDate!,
    );
    TransactionDB.instance.addTransaction(newModel);
    Navigator.of(context).pop();
    TransactionDB.instance.refreshUI();
  }
}
