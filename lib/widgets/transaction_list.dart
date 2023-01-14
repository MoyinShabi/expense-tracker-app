import 'package:flutter/material.dart';

import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final void Function(String) deleteTx;
  final void Function(Transaction, int) snackBarAction;

  const TransactionList(
      {super.key,
      required this.transactionList,
      required this.deleteTx,
      required this.snackBarAction});

  @override
  Widget build(BuildContext context) {
    return transactionList.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'No transactions added yet...',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: constraints.maxHeight * 0.5,
                  // The height of the `SizedBox()` helps to infer the size into
                  // which the the image should be squeezed in its parent- `Column()`.
                  // In this case, 50% of it.
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: transactionList.length,
            itemBuilder: (context, index) {
              return TransactionItem(
                  transaction: transactionList[index], deletetx: deleteTx);
            },
          );
  }
}
