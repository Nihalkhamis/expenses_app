import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  // const ChartBar({Key? key}) : super(key: key);

  final String label;
  final double spendingAmount;
  final double totalAmountPrc;

  const ChartBar(this.label, this.spendingAmount, this.totalAmountPrc);

  @override
  Widget build(BuildContext context) {
    print("ChartBar build");

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text("\$${spendingAmount.toStringAsFixed(2)}"))
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            width: 10,
            height: constraints.maxHeight * 0.6,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  // box, it's size will be as a fraction of the surrounding container
                  heightFactor: totalAmountPrc,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
              child: FittedBox(
                  child: Text(label)
              )
          ),
        ],
      );
      }
      ,);

  }
}
