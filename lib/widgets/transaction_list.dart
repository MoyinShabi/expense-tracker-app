import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import 'package:personal_expenses_app/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionList;
  final void Function(String) deletetx;
  final void Function(Transaction, int) snackBarAction;

  const TransactionList(
      {super.key,
      required this.transactionList,
      required this.deletetx,
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
                  // The height of the `SizedBox()` helps to infer the size into
                  // which the the image should be squeezed in its parent- `Column()`
                  height: constraints.maxHeight * 0.5,
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
              return Card(
                // elevation: 3,
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
                          '₦${transactionList[index].amount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    transactionList[index].title,
                    // style: Theme.of(context).textTheme.headline1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactionList[index].date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: MediaQuery.of(context).size.width >
                          400 // Checks the width of the screen
                      ? TextButton.icon(
                          onPressed: () {
                            deletetx(transactionList[index].id);
                          },
                          label: const Text('Delete'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          icon: const Icon(Ionicons.trash_outline))
                      : IconButton(
                          onPressed: () {
                            deletetx(transactionList[index].id);
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
            },
          );
  }
}
