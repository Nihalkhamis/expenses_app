import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  Color? _bgColor;

  @override
  void initState() {
    super.initState();

    const availableColors = [Colors.black, Colors.blue, Colors.red, Colors.green];
    _bgColor = availableColors[Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
                child: Text(
                    "\$${widget.transaction.amount.toStringAsFixed(2)}")),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat()
              .add_yMMMMd()
              .format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
            onPressed: () => widget.deleteTx(widget.transaction.id),
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
            label: Text(
              "Delete",
              style: TextStyle(
                  color: Theme.of(context).errorColor),
            ))
            : IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => widget.deleteTx(widget.transaction.id),
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }
}