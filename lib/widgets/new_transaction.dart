import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class NewTransaction extends StatefulWidget {
  final void Function(String, int, DateTime) addTx;

  const NewTransaction({super.key, required this.addTx});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  // ^ These help to listen to every keystroke and get the values once
  // you're done.

  DateTime? _selectedDate;

  // Date Picker
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  // Function refactored to help with the submission of all entered inputs
  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = int.parse(_amountController.text);

    // Checking all edge-cases to not allow an invald transaction to get
    // added to the list:
    if (enteredTitle.isEmpty ||
        (_amountController.text.isEmpty) ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return; // Stops the function execution
    }

    widget.addTx(enteredTitle, enteredAmount, _selectedDate!);
    // `widget` used above is a special getter/property which helps to access
    // properties and methods of the widget class, inside the state class, and
    // in this case, `addTx`.

    Navigator.of(context).pop();
    // Helps to go back to the transaction list screen / automatically close the
    // bottom sheet after a transaction is added or submitted.
    // The `pop()` method helps to close (by "popping" it off) the topmost screen
    // that is displayed- the modal bottom sheet.
  }

  void _exitSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 14,
          right: 14,
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  child: const Text(
                    'New Transaction',
                    // style: Theme.of(context).textTheme.headline6,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                    onPressed: _exitSheet,
                    icon: const Icon(Ionicons.close_circle_outline))
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                // Flutter automatically connects to controllers of the text fields,
                // and the controllers listen to the user input and saves them.
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date chosen'
                          : 'Date: ${DateFormat('EEE, d/M/y').format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: _submitData,
                child: const Text('Add Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
