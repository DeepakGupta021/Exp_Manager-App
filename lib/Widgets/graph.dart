import '../Models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import './bar.dart';

class Graph extends StatelessWidget {
  final List<Transaction> transaction;
  final int daysInput;
  final Function setMonthlyTotal;
  Graph(this.transaction, this.daysInput, this.setMonthlyTotal);

  List<Map<String, Object>> get chartData {
    return List.generate(daysInput, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      //print(weekDay.day.toString());

      int totalSum = 0;

      for (var i = 0; i < transaction.length; i++) {
        //print(
        //   "${transaction[i].date.month} == ${weekDay.month} ${transaction[i].date.day} == ${weekDay.year} ${transaction[i].date.day} == ${weekDay.year}");

        if (transaction[i].date.month == weekDay.month &&
            transaction[i].date.day == weekDay.day &&
            transaction[i].date.year == weekDay.year) {
          totalSum += transaction[i].amount;
          //print("Amount ${transaction[i].amount}");
        }
      }

      return {
        "Day": daysInput == 7
            ? DateFormat.E().format(weekDay).substring(0, 1)
            : weekDay.day.toString(),
        "Amt": totalSum
      };
    });
  }

  double get totalSpending {
    return chartData.fold(0.0, (sum, item) {
      return sum += item["Amt"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraint)
    {
      return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          height: daysInput==7? constraint.maxHeight * 0.85 : 180,
          //width: double.infinity,
          child: daysInput == 7
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //scrollDirection: Axis.horizontal,
                children: chartData.reversed.map((e) {
                  return Flexible(
                    fit: FlexFit.tight,
                    child: BarClass(
                        label: e['Day'],
                        percen: totalSpending == 0
                            ? 0
                            : ((e['Amt'] as int) / totalSpending),
                        spentAmt: e['Amt']),
                  );
                }).toList(),
              )
              : ListView(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  scrollDirection: Axis.horizontal,
                  children: chartData.map((e) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: BarClass(
                          label: e['Day'],
                          percen: totalSpending == 0
                              ? 0
                              : ((e['Amt'] as int) / totalSpending),
                          spentAmt: e['Amt']),
                    );
                  }).toList(),
                ),
        ),
        Container(
            height:daysInput==7? constraint.maxHeight * 0.15:30,
            child: FittedBox(
                child: Text(
              "Total ₹ $totalSpending",
              style: Theme.of(context).textTheme.headline6,
            ))),
      ],
    );
    });
  }
}
