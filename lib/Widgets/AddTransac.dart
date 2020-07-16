import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransac extends StatefulWidget {
  final Function updateTransac;
  AddTransac(this.updateTransac);

  @override
  _AddTransacState createState() => _AddTransacState();
}

class _AddTransacState extends State<AddTransac> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final personController = TextEditingController(text: "Unknown");

  DateTime selectedDate;
  void datePicker() {
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
          selectedDate = pickedDate;
        });
      }
    });
  }

  void userInput() {
    if (titleController.text.isEmpty ||
        amountController.text.isEmpty ||
        int.parse(amountController.text) <= 0 ||
        selectedDate == null ||
        personController.text == null) {
      return;
    }

    try {
      int amt = int.parse(amountController.text);
      widget.updateTransac(
          personController.text, titleController.text, amt, selectedDate);
      Navigator.of(context).pop();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              left: 10,
              right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Person",
                  ),
                  controller: personController,
                  onSubmitted: (_) => userInput(),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(hintText: "Title"),
                  controller: titleController,
                  onSubmitted: (_) => userInput(),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(hintText: "Amount"),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => userInput(),
                ),
              ),
              Container(
                height: 35,
                margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "No Date Choosen!"
                            : "${DateFormat.yMMMd().format(selectedDate)}",
                      ),
                    ),
                    FlatButton(
                      onPressed: datePicker,
                      child: Text(
                        "Choose Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 21),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: userInput,
                child: Text(
                  "Add Transaction",
                  style: TextStyle(color: Theme.of(context).buttonColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
