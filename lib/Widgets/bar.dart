import 'package:flutter/material.dart';

class BarClass extends StatelessWidget {
  final String label;
  final int spentAmt;
  final double percen;

  BarClass(
      {@required this.label, @required this.percen, @required this.spentAmt});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              height: constraint.maxHeight * 0.15,
              child: FittedBox(child: Text("₹ $spentAmt"))),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            height: constraint.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Color.fromRGBO(200, 200, 200, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percen,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(height: constraint.maxHeight * 0.15,child: FittedBox(child: Text("$label"))),
        ],
      );
    });
  }
}
