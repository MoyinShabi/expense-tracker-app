// This is just a blueprint for a normal Dart Object which will be used in the
// Dart code in the app.
class Transaction {
  // These are the four properties that will make up a transaction in the app:
  final String id;
  final String title;
  final int amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  String toString() {
    return "Transaction: $title";
  }
}
