import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:secondapp/widgets/chart.dart';
import 'package:secondapp/widgets/newtransaction.dart';
import 'package:secondapp/widgets/transactionwidget.dart';
import './modules/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PERSONAL EXPENSES',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List transactions = [
    // Transaction(
    //     id: "t1", title: "Newshoes", amount: 500, dateTime: DateTime.now()),
    // Transaction(
    //     id: "t2", title: "Groceries", amount: 100, dateTime: DateTime.now()),
    // Transaction(
    //     id: "t1", title: "Vegetables", amount: 200, dateTime: DateTime.now())
  ];
  List get recenttransaction {
    return transactions.where((tx) {
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool showchart = false;

  void Newusertransaction(String ttitle, double tamount, DateTime chosendate) {
    final newut = Transaction(
        amount: tamount,
        title: ttitle,
        dateTime: chosendate,
        id: DateTime.now().toString());
    setState(() {
      transactions.add(newut);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Newtransaction(Newusertransaction));
      },
    );
  }

  void deletetransaction(String id) {
    setState(() {
      transactions.removeWhere((newut) => newut.id == id);
    });
  }

  List<Widget> buildlandscapecontent(
      MediaQueryData mediaquery, AppBar appbar, Widget txwidget) {
    return [
      Row(
        children: [
          Text('Show Chart'),
          Switch(
              value: showchart,
              onChanged: (val) {
                setState(() {
                  showchart = val;
                });
              })
        ],
      ),
      showchart
          ? Container(
              height: (mediaquery.size.height -
                      appbar.preferredSize.height -
                      mediaquery.padding.top) *
                  0.7,
              child: Chart(recenttransaction))
          : txwidget,
    ];
  }

  List<Widget> buildportraitcontent(
      MediaQueryData mediaquery, AppBar appbar, Widget txwidget) {
    return [
      Container(
          height: (mediaquery.size.height -
                  appbar.preferredSize.height -
                  mediaquery.padding.top) *
              0.3,
          child: Chart(recenttransaction)),
      txwidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscape = mediaquery.orientation == Orientation.landscape;
    final appbar = AppBar(
      title: Text(
        "PERSONAL EXPENSES",
        style: TextStyle(fontFamily: "OpenSans"),
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              startAddNewTransaction(context);
            })
      ],
    );
    final txwidget = Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.7,
        child: Transactionlist(transactions, deletetransaction));
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            if (isLandscape)
              ...buildlandscapecontent(mediaquery, appbar, txwidget),
            if (!isLandscape)
              ...buildportraitcontent(mediaquery, appbar, txwidget),
          ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}
