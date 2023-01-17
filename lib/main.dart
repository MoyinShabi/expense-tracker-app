import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

void main() {
  /* WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]); */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.amber),
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        )),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  // Empty List of Transactions
  final List<Transaction> _userTransactions = [];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  // This method will be called whenever your lifecycle state changes /
  // whenever the app reaches a new state in the lifecycle.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // MANAGING THE TRANSACTIONS
  // Getting transactions only from the past 6 days + today:
  List<Transaction> get _recentTransactons {
    return _userTransactions
        .where(
          (transaction) => transaction.date.isAfter(
            DateTime.now().subtract(
              const Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  // Method to help add new transactions to the list of transactions:
  void _addnewTransaction(String txTitle, int txAmount, DateTime txDate) {
    final newTransaction = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  // Modal Bottom Sheet
  void _showNewTransactionSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewTransaction(addTx: _addnewTransaction);
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
    );
  }

  // Delete a transaction in the list
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere(((tx) => id == tx.id));
    });
  }

  // Undo Delete snack bar
  void _undoDelete(Transaction tx, int index) {
    setState(() {
      _userTransactions.insert(index, tx);
    });
  }

  // Builder method
  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txChartWidget,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Show Chart'),
          Switch.adaptive(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: _showChart,
              onChanged: (value) {
                setState(() {
                  _showChart = value;
                });
              }),
        ],
      ),
      _showChart ? txChartWidget : txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    // print(_recentTransactons);
    print('`build()` MyHomePageState');
    final mediaQuery = MediaQuery.of(context);

    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text(
        'Expense Tracker',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      /*  actions: [
        IconButton(
          onPressed: () => _showNewTransactionSheet(context),
          icon: Icon(
            Ionicons.add_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ], */
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        // statusBarBrightness: Brightness.light, // For iOS (light icons)
      ),
    );

    final isPortrait = mediaQuery.orientation ==
        Orientation.portrait; // Helps to check the orientation of the device

    final availableHeight = (mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top);
    // ^ The available height of the screen calulated is the full height of the device
    // minus the appBar minus the status bar.

    final transactionListWidget = SizedBox(
      height: availableHeight *
          (isPortrait ? 0.73 : 0.7), // % of the available height of the screen
      child: TransactionList(
        transactionList: _userTransactions,
        deleteTx: _deleteTransaction,
        snackBarAction: _undoDelete,
      ),
    );

    final transactionChartWidget = SizedBox(
      height: availableHeight * (isPortrait ? 0.27 : 0.6),
      child: Chart(_recentTransactons),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Collection-if:
            if (isPortrait) ...[transactionChartWidget, transactionListWidget],

            if (!isPortrait)
              ..._buildLandscapeContent(mediaQuery, appBar,
                  transactionChartWidget, transactionListWidget)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.black,
        onPressed: () => _showNewTransactionSheet(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
