import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/adaptive_text_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

   NewTransaction(this.addNewTx){
   print("Constructor NewTransaction Widget");
  }

  @override
  State<NewTransaction> createState() {
    print("createState NewTransaction Widget");
      return  _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {

  _NewTransactionState(){
    print("Constructor NewTransaction State");
  }

  @override
  void initState() {
    super.initState();
    print("initState()");
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget()");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose()");
  }

  // const NewTransaction({Key? key}) : super(key: key);
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addNewTx(enteredTitle, enteredAmount, _selectedDate); //widget to access any property and method of my widget class inside state class
    Navigator.of(context).pop(); //close the last widget on top and context is here by default inside any state class
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                //onChanged: (value) => title = value,
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                //onChanged: (value) => amount = value,
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_selectedDate == null
                            ? "No Date Chosen"
                            : "Picked date: ${DateFormat.yMd().format(_selectedDate!)}")
                    ),
                    AdaptiveTextButton("Choose Date", _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _submitData,
                  // style: ButtonStyle(),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    textStyle: Theme.of(context).textTheme.button,
                    // textStyle: Theme
                  ),
                  child: const Text("Add transaction")
              )
            ],
          ),
        ),
      ),
    );
  }
}
