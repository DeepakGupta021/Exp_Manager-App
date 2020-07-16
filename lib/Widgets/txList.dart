import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/transaction.dart';

class TxList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  final DateTime choosenDate;
  TxList({this.transactions, this.deleteTx, this.choosenDate});

  List<Transaction> get transacForDay {
    return transactions
        .where((element) => element.date.day == choosenDate.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(builder: (ctx, constraint) {
      return Column(
        children: <Widget>[
          Container(
            height: mediaQuery.orientation == Orientation.landscape
                ? constraint.maxHeight * 0.2
                : constraint.maxHeight * 0.08,
            child: FittedBox(
                child: Text("${DateFormat.yMMMd().format(choosenDate)}")),
          ),
          Container(
            height: mediaQuery.orientation == Orientation.landscape
                ? constraint.maxHeight * 0.8
                : constraint.maxHeight * 0.92,
            child: transacForDay.isEmpty
                ? Column(
                    children: <Widget>[
                      Container(
                        height: mediaQuery.orientation == Orientation.landscape
                            ? constraint.maxHeight * 0.4
                            : constraint.maxHeight * 0.9,
                        child: FittedBox(
                          child: Text(
                            "No Transaction Added!!!",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constraint.maxHeight * 0.1,
                      ),
                      mediaQuery.orientation == Orientation.landscape
                          ? Container()
                          : Container(
                              height: constraint.maxHeight * 0.9,
                              child: Image.asset('assets/img/Wait.png'),
                            ),
                    ],
                  )
                : ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 10,
                        child: Container(
                          height: 90,
                          child: ListTile(
                            leading: Container(
                              child: CircleAvatar(
                                radius: 40,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: FittedBox(
                                      child: Text(
                                          "₹${transacForDay[index].amount}")),
                                ),
                              ),
                            ),
                            title: Container(
                              width: 150,
                              child: Text(
                                "${transacForDay[index].uName}",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            subtitle: Text(
                              "${transacForDay[index].pName}",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: MediaQuery.of(context).size.width > 400
                                ? FlatButton.icon(
                                    onPressed: () =>
                                        deleteTx(transacForDay[index].id),
                                    icon: Icon(Icons.delete),
                                    label: Text("Delete"),
                                    textColor: Theme.of(context).errorColor,
                                  )
                                : FlatButton(
                                    onPressed: () =>
                                        deleteTx(transacForDay[index].id),
                                    child: Icon(
                                      Icons.delete,
                                      color: Theme.of(context).errorColor,
                                    )),
                          ),
                        ),
                      );
                    },
                    itemCount: transacForDay.length,
                  ),
          ),
        ],
      );
    });
  }
}
