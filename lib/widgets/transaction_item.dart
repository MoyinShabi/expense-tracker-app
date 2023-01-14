import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:personal_expenses_app/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deletetx,
  }) : super(key: key);

  final Transaction transaction;
  final void Function(String) deletetx;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '₦${transaction.amount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          // style: Theme.of(context).textTheme.headline1,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: MediaQuery.of(context).size.width >
                400 // Checks the width of the screen
            ? TextButton.icon(
                onPressed: () {
                  deletetx(transaction.id);
                },
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Ionicons.trash_outline))
            : IconButton(
                onPressed: () {
                  deletetx(transaction.id);
                  /*  final snackBar = SnackBar(
                    content: Text(
                      "${transactionList[index].title} Deleted",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        snackBarAction(transactionList[index], index);
                      },
                    ),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar); */
                },
                color: Colors.black,
                icon: const Icon(Ionicons.trash_outline),
              ),
      ),
    );
  }
}
