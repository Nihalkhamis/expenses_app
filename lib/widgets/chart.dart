import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';
import './chart_bar.dart';


class Chart extends StatelessWidget {
  // const Chart({Key? key}) : super(key: key);
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions){
    print("Chart Constructor");
  }

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // print("Day name---->${DateFormat.E().format(weekDay)}");
      // print(totalSum);

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),  // one letter that represents each day of the week
        "amount": totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending{
    return groupedTransactionValues.fold(0.0, (previousValue, element) => previousValue + element["amount"]);  //extract a double from a list and return it
  }

  @override
  Widget build(BuildContext context) {
    print("Chart build");

    // print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
            groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    data["day"],
                    data["amount"],
                   totalSpending == 0 ? 0.0 : data["amount"]/totalSpending
                ),
              );
            }).toList(),
        ),
      ),
    );
  }
}
