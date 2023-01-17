import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:personal_expenses_app/models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deletetx,
  }) : super(key: key);

  final Transaction transaction;
  final void Function(String) deletetx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color? _bgColor;

  @override
  void initState() {
    super.initState();
    const availableColors = [
      Colors.amber,
      Colors.black,
      Colors.grey,
      Colors.indigo
    ];
    _bgColor = availableColors[Random().nextInt(4)];
    // There's no need to wrap `_bgColor` here in `initState()` into `setState((){})`
    // because `initState()` is normally called before `build()` is executed. So,
    // `build()` will normally take into account any changes made in `initState()`.
  }

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
          // backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundColor: _bgColor,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '₦${widget.transaction.amount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          // style: Theme.of(context).textTheme.headline1,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: MediaQuery.of(context).size.width >
                400 // Checks the width of the screen
            ? TextButton.icon(
                onPressed: () {
                  widget.deletetx(widget.transaction.id);
                },
                label: const Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Ionicons.trash_outline))
            : IconButton(
                onPressed: () {
                  widget.deletetx(widget.transaction.id);
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
