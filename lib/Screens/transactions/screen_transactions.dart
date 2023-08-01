import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_managment_app/db/category/category_db.dart';
import 'package:money_managment_app/db/transactions/transaction_db.dart';
import 'package:money_managment_app/models/category/category_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/transaction/transaction_model.dart';

class ScreenTrancaction extends StatelessWidget {
  const ScreenTrancaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refreshUI();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            final TransactionItem = newList[index];
            return Slidable(
              key: Key(TransactionItem.id!),
              startActionPane: ActionPane(
                motion: DrawerMotion(),
                children: [
                  SlidableAction(
                    padding: EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.red,
                    onPressed: (ctx) {
                      TransactionDB.instance
                          .deleteTransaction(TransactionItem.id!);
                    },
                    icon: Icons.delete_forever,
                    label: 'Delete',
                  )
                ],
              ),
              child: Card(
                child: ListTile(
                  title: Text('RS ${TransactionItem.amount}'),
                  subtitle: Text(TransactionItem.purpose),
                  leading: CircleAvatar(
                    // foregroundColor: Colors.white,
                    backgroundColor: TransactionItem.type == CategoryType.income
                        ? Colors.greenAccent[400]
                        : Colors.pink[400],
                    radius: 50.0,
                    child: Text(
                      parseDate(TransactionItem.date),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return SizedBox(
              height: 5,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitted = _date.split(' ');
    return '${_splitted[1]}\n ${_splitted[0]} ';
  }
}
