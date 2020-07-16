import 'dart:collection';
import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import './Models/transaction.dart';
import './Widgets/AddTransac.dart';
import './Widgets/txList.dart';
import './Widgets/graph.dart';
import './Widgets/monthTransac.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  */
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ex Manager",
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: "IndieFlower",
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontSize: 22,
          ),
          headline6: TextStyle(
            fontSize: 22,
            fontFamily: 'Lemonada',
            color: Colors.purple,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime datechoose;
  double monthlyTotal;

  Queue<Transaction> redo = new Queue();

  final List<Transaction> transactions = [
    Transaction(
        amount: 500,
        date: DateTime.now(),
        id: "t1",
        uName: "Shirt",
        pName: "shopKeeper"),
    Transaction(
        amount: 1000,
        date: DateTime.now(),
        id: "t2",
        uName: "Shoes",
        pName: "shopKeeper"),
    Transaction(
        amount: 500,
        date: DateTime.now(),
        id: "t3",
        uName: "Shirt",
        pName: "shopKeeper"),
    Transaction(
        amount: 500,
        date: DateTime.now(),
        id: "t4",
        uName: "Shirt",
        pName: "shopKeeper"),
  ];

  List<Transaction> get recentTransac {
    return transactions.where((element) {
      print(element.amount);
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void monthlyTransac(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return ListView(scrollDirection: Axis.vertical, children: <Widget>[
          MonthTransac(transactions, monthlyTotal),
        ]);
      },
    );
  }

  void toAddNewTrasac(BuildContext ctx, Function updateTransac) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return AddTransac(updateTransac);
      },
    );
  }

  void datePickerMain() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          datechoose = pickedDate;
        });
      }
    });
  }

  void updateTransac(
      String person, String title, int amount, DateTime choosenDate) {
    final Transaction t = Transaction(
        id: DateTime.now().toString(),
        amount: amount,
        pName: person,
        uName: title,
        date: choosenDate);

    setState(() {
      transactions.add(t);
    });
  }

  void deleteTransac(String id) {
    setState(() {
      try {
        //redo.addAll(transactions.where((element) => element.id == id));
        for (var item in transactions) {
          if(item.id==id)
          {
            redo.addLast(item);
            break;
          }
            
        }

      } catch (e) {}
      finally{
      transactions.removeWhere((element) => element.id == id);
      }
    });
  }

  void undo() {
    if (redo == null) {
      return;
    }
    setState(() {
      transactions.add(redo.last);
      redo.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool x = mediaQuery.orientation == Orientation.landscape;
    final appBarvar = AppBar(
      title: Title(color: Colors.blue, child: Text("Ex Manager2")),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 40,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: FlatButton(
                child: Icon(
                  Icons.undo,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: undo,
              ),
            ),
            Container(
              width: 65,
              child: FlatButton(
                child: Icon(
                  Icons.date_range,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => datePickerMain(),
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: appBarvar,
      body:LayoutBuilder(builder: (ctx,constraint){
        return Column(
        children: <Widget>[
          Container(
            height: x
                ? (mediaQuery.size.height -
                        appBarvar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.6
                : (mediaQuery.size.height -
                        appBarvar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.35,
              width:constraint.maxWidth<600?double.infinity:600,
            child: Card(
              elevation: 8,
              margin: EdgeInsets.all(10),
              shadowColor: Color.fromRGBO(100, 500, 700, 1),
              child: FlatButton(
                child: Graph(recentTransac, 7, () {}),
                onPressed: () => monthlyTransac(context),
              ),
            ),
          ),
          Container(
            height: x
                ? (mediaQuery.size.height -
                        appBarvar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.4
                : (mediaQuery.size.height -
                        appBarvar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.65,
            width:constraint.maxWidth<600?double.infinity:600,
            child: TxList(
              transactions: transactions,
              deleteTx: deleteTransac,
              choosenDate: datechoose == null ? DateTime.now() : datechoose,
            ),
          ),
        ],
      );
      }), 
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => toAddNewTrasac(context, updateTransac),
        child: Icon(
          Icons.account_balance_wallet,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
