import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions, {super.key}) {
    print('`Constructor Chart`');
  }

  // Getter to generate the list of transactions grouped per day as Maps:
  List<Map<String, Object>> get transactionsByWeekday {
    // The constructor below calls the function which is the 2nd argument, for every
    // iteration, from index 0-6
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      // ^ Dates from the last 6 days +  today

      var totalSum = 0; // Sum of transactions in a day.

      for (var transaction in recentTransactions) {
        /* if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalSum += transaction.amount;
        } */
        if (DateFormat.yMMMEd().format(transaction.date) ==
            DateFormat.yMMMEd().format(weekDay)) {
          totalSum += transaction.amount;
        }
        // ^ The condition in the if statement checks if we're looking at a transaction that
        // happened on the weekday being considered for the current item in
        // the list generation.
      }

      // print(DateFormat.E().format(weekDay));
      // print(totalSum);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 2),
        'amount': totalSum,
      };
    });
  }

  // Total of all transactions in the past 6 days + today:
  int get totalSpending {
    return transactionsByWeekday.fold(0,
        (currentValue, element) => currentValue + (element['amount'] as int));
  }

  @override
  Widget build(BuildContext context) {
    // print(transactionsByWeekday);
    print('`build() Chart`');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8,
      // margin: EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: transactionsByWeekday.reversed
              .map((data) => Expanded(
                    child: ChartBar(
                      label: data['day'] as String,
                      weekdayTotalAmount: data['amount'] as int,
                      percentageOfTotalAmount: totalSpending == 0
                          ? 0.0
                          : (data['amount'] as int) / totalSpending,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
