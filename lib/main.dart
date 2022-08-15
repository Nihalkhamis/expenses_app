import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transactions.dart';

void main() {
  // to control the orientation of the device on this app
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          accentColor: Colors.amberAccent,
          fontFamily: "Quicksand",
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: const TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: const TextStyle(color: Colors.white),
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
          )),
          appBarTheme: const AppBarTheme(
              // textTheme: ThemeData.light().textTheme.copyWith(
              //     headline6: TextStyle(
              //     fontFamily: "OpenSans",
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold
              //   )
              // )
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))),
      title: 'Personal Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: "t1", title: "Adidas shoes", amount: 99.99, date: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "Nike t-shirt", amount: 55.55, date: DateTime.now()),
  ];
  bool _showChart = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);  // when lifecycle changes go to a certain observer and call didChangeAppLifeCycleState()
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)   // will call when lifecycle changes
  {
    print(state);
  }


  @override
  void dispose() {
    super.dispose();
     WidgetsBinding.instance.removeObserver(this);
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      // where return iterable not a list
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        // date: DateTime.now(),
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) // builder takes context in normal case if needed, and this builder rebuild NewTransaction Widget
            {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(_addNewTransaction),
          );
        });
  }

  List<Widget> _buildLandscapeMethod(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Show Chart", style: Theme.of(context).textTheme.headline6),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (value) => setState(() {
              _showChart = value;
            }),
          )
        ],
      ),
      _showChart
          ? Container(
              height: mediaQuery.size.height * 0.7 -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitMethod(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
          height: mediaQuery.size.height * 0.3 -
              appBar.preferredSize.height -
              mediaQuery.padding.top,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("MyHomePageState build");

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text(
              'Personal Expenses',
            ),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              )
            ],
          );
    final txListWidget = Container(
      height: mediaQuery.size.height * 0.7 -
          appBar.preferredSize.height -
          mediaQuery.padding.top,
      child: TransactionList(_transactions, _deleteTransaction),
    );
    final pageBody = SafeArea(
      // SafeArea to make sure that all widgets are positioned inside boundaries not outside in case of ios phone
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeMethod(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitMethod(
                  mediaQuery, appBar, txListWidget), // ... spread operator
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: const Icon(Icons.add)),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }
}
