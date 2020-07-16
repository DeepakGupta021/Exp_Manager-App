import 'package:Exp_Manager/Models/transaction.dart';
import 'package:Exp_Manager/Widgets/graph.dart';
import 'package:flutter/material.dart';

class MonthTransac extends StatefulWidget {
  final List<Transaction> _transactions;
  double total;

  MonthTransac(this._transactions,this.total);


  List<Transaction> get _monthTransac {
    return _transactions.where((element) {
      print(element.amount);
      return element.date.isAfter(DateTime.now().subtract(Duration(days: 30)));
    }).toList();
  }
  

  @override
  _MonthTransacState createState() => _MonthTransacState();
}

class _MonthTransacState extends State<MonthTransac> {
  void setMonthlytotal(double total)
  {
    setState(() {
      widget.total=total;
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,child: Graph(widget._monthTransac, 30,setMonthlytotal));
  }
}
