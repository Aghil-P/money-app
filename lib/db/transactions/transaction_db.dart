import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: unused_import
import 'package:money_managment_app/models/category/category_model.dart';
import 'package:money_managment_app/models/transaction/transaction_model.dart';

// ignore: constant_identifier_names
const String TRANSACTION_DB_NAME = 'Transaction-db';

abstract class TransactionDbFunctions {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel obj);
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _transactionDB.put(obj.id, obj);
  }

  Future<void> refreshUI() async {
    final _transactionList = await getTransactions();
    _transactionList.sort(
      (first, second) => second.date.compareTo(first.date),
    );

    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_transactionList);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final _transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _transactionDB.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _transactionDB.delete(id);
    refreshUI();
  }
}
