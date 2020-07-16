import 'package:flutter/foundation.dart';

class Transaction {
  String id;
  String pName;
  String uName;
  int amount;
  DateTime date;

  Transaction(
      {@required this.id,
      @required this.amount,
      @required this.pName,
      @required this.uName,
      @required this.date});

  
}
