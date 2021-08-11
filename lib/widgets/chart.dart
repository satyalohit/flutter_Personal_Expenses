import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:secondapp/modules/transaction.dart';
import 'package:secondapp/widgets/chartbar.dart';

class Chart extends StatelessWidget {
  final List recenttransaction;
  Chart(this.recenttransaction);
  List<Map<String, Object>> get groupedtransactionvalue {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalsum = 0.0;
      for (var i = 0; i < recenttransaction.length; i++) {
        if (recenttransaction[i].dateTime.day == weekday.day &&
            recenttransaction[i].dateTime.month == weekday.month &&
            recenttransaction[i].dateTime.year == weekday.year) {
          totalsum += recenttransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalsum
      };
    }).reversed.toList();
  }

  double get totalspending {
    return groupedtransactionvalue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *0.4,
      child: Card(
          elevation: 6,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedtransactionvalue.map((e) {
                return Flexible(
                  fit: FlexFit.tight,
                    child: ChartBar(
                        e['day'],
                        e['amount'],
                        totalspending == 0.0
                            ? 0.0
                            : (e["amount"] as double) / totalspending));
              }).toList(),
            ),
          )),
    );
  }
}
