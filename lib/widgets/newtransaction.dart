import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Newtransaction extends StatefulWidget {
  final Function newtransaction;
  Newtransaction(this.newtransaction);

  @override
  _NewtransactionState createState() => _NewtransactionState();
}

class _NewtransactionState extends State<Newtransaction> {
  final titlecontroller = TextEditingController();
  final amountcontroller = TextEditingController();
  DateTime selecteddate;

  void submitData() {
    if (amountcontroller.text.isEmpty) {
      return;
    }
    final text = titlecontroller.text;
    final amount = double.parse(amountcontroller.text);
    if (text.isEmpty || amount <= 0 || selecteddate == null) {
      return;
    }
    widget.newtransaction(text, amount, selecteddate);
    Navigator.of(context).pop();
  }

  void presentdatepicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickeddate) {
      if (pickeddate == null) {
        return;
      }
      setState(() {
        selecteddate = pickeddate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
          elevation: 6,
          child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom+10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titlecontroller,
                  onSubmitted: (_) => submitData(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Amount"),
                  controller: amountcontroller,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => submitData(),
                ),
                Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selecteddate == null
                            ? 'No Date Chosen'
                            : 'Picked date ${DateFormat.yMd().format(selecteddate)}',
                      ),
                      TextButton(
                          onPressed: presentdatepicker,
                          child: Text(
                            "Choose Date",
                          ),
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                    ),
                    onPressed: submitData,
                    child: Text(
                      "Add Transaction",
                      style: TextStyle(fontSize: 16),
                    ))
              ],
            ),
          )),
    );
  }
}
