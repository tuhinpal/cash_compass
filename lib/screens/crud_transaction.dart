import 'package:cash_compass/components/ui/date_picker.dart';
import 'package:cash_compass/components/ui/dropdown_form.dart';
import 'package:cash_compass/components/ui/text_field.dart';
import 'package:cash_compass/helpers/db.dart';
import 'package:flutter/material.dart';
import 'package:cash_compass/helpers/constants.dart';

class CrudTransaction extends StatefulWidget {
  final Transaction? transaction;

  const CrudTransaction({Key? key, this.transaction}) : super(key: key);

  @override
  State<CrudTransaction> createState() => _CrudTransactionState();
}

class _CrudTransactionState extends State<CrudTransaction> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _dateController = TextEditingController();
  Map _typeSelected = transactionTypes[0];
  Map? _categorySelected; // Defaults to null

  String _currencySelected = currencies[0]['currency'].toString();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note;
      _dateController.text = widget.transaction!.date;
      _typeSelected = transactionTypes
          .firstWhere((type) => type['name'] == widget.transaction!.type);
      _categorySelected = (_typeSelected['categories'] as List).firstWhere(
          (category) => category['name'] == widget.transaction!.category);
      _currencySelected = widget.transaction!.currency;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? 'Add Transaction'
            : 'Update ${widget.transaction!.type}'),
        backgroundColor: _typeSelected['color'],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // ONLY SHOW TYPE SELECTOR IF TRANSACTION IS NULL
              if (widget.transaction == null)
                Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),

                    // EXPENSE/INCOME
                    Center(
                      child: ToggleButtons(
                        isSelected: transactionTypes
                            .map(
                                (type) => _typeSelected['name'] == type['name'])
                            .toList(),
                        onPressed: (int index) {
                          setState(() {
                            _typeSelected = transactionTypes[index];
                            _categorySelected =
                                null; // Reset category selection on type change
                          });
                        },
                        color: Colors.white,
                        fillColor: _typeSelected['color'],
                        borderRadius: BorderRadius.circular(5),
                        renderBorder: true,
                        children: transactionTypes
                            .map((type) => Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0,
                                    right: 30.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Column(
                                  children: [
                                    Icon(type['icon'],
                                        color: _typeSelected == type
                                            ? Colors.white
                                            : type['color']),
                                    Text(type['name'],
                                        style: TextStyle(
                                            color: _typeSelected == type
                                                ? Colors.white
                                                : type['color'])),
                                  ],
                                )))
                            .toList(),
                      ),
                    ),
                  ],
                ),

              // GAP
              const SizedBox(
                height: 20.0,
              ),

              // CURRENCY & AMOUNT
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: StyledDropdownButtonFormField(
                        items: currencies
                            .map((currency) => DropdownMenuItem(
                                  value: currency['currency'],
                                  child: Text(currency['currency']),
                                ))
                            .toList(),
                        value: _currencySelected,
                        onChanged: (value) {
                          setState(() {
                            _currencySelected = value as String;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an item';
                          }
                          return null;
                        },
                        labelText: 'Currency',
                        color: _typeSelected['color'],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Add space between the two fields
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: StyledTextField(
                        key: const Key('amount'),
                        color: _typeSelected['color'],
                        controller: _amountController,
                        labelText: 'Amount',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // GAP
              const SizedBox(
                height: 20.0,
              ),

              // CATEGORY
              StyledDropdownButtonFormField(
                items: (_typeSelected['categories'] as List)
                    .map((category) => DropdownMenuItem(
                          value: category['name'],
                          child: Row(
                            children: [
                              Icon(category['icon'],
                                  color: _typeSelected['color']),
                              const SizedBox(width: 10),
                              Text(category['name']),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  debugPrint("Selected: $value");
                  setState(() {
                    _categorySelected = (_typeSelected['categories'] as List)
                        .firstWhere((category) => category['name'] == value);
                  });
                },
                labelText: 'Choose a category',
                value: _categorySelected != null
                    ? _categorySelected!['name']
                    : null,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                color: _typeSelected['color'],
              ),

              // GAP
              const SizedBox(
                height: 20.0,
              ),

              // DATE
              StyledDatePicker(
                key: const Key('date'),
                labelText: 'Transaction Date',
                color: _typeSelected['color'],
                controller: _dateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),

              // GAP
              const SizedBox(
                height: 20.0,
              ),

              // NOTE
              StyledTextField(
                key: const Key('note'),
                color: _typeSelected['color'],
                controller: _noteController,
                labelText: 'Note',
                keyboardType: TextInputType.multiline,
                rows: 3,
              ),

              // GAP
              const SizedBox(
                height: 20.0,
              ),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var dbHelper = DatabaseHelper();
                    var transaction = Transaction(
                      id: widget.transaction != null
                          ? widget.transaction!.id
                          : null,
                      currency: _currencySelected,
                      amount: double.parse(_amountController.text),
                      date: _dateController.text,
                      category: _categorySelected?['name'],
                      note: _noteController.text,
                      type: _typeSelected['name'],
                    );

                    debugPrint(transaction.toMap().toString());

                    if (widget.transaction == null) {
                      dbHelper.saveTransaction(transaction).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Transaction saved successfully')));
                        Navigator.of(context).pop(); // Close the dialog
                      });
                    } else {
                      dbHelper.updateTransaction(transaction).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Transaction updated successfully')));
                        Navigator.of(context).pop(); // Close the dialog
                      });
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(_typeSelected['color']),
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                    top: 12.0,
                    bottom: 12.0,
                  )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centers the children horizontally
                  children: <Widget>[
                    Icon(
                      widget.transaction == null ? Icons.add : Icons.update,
                    ),
                    const SizedBox(
                        width: 10), // Creates space between the icon and text
                    Text(
                      "${widget.transaction == null ? "Add" : "Update"} ${_typeSelected['name'].toString().toLowerCase()}",
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),

              if (widget.transaction != null)
                Column(
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text(
                                  'Are you sure you want to delete this transaction?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    var dbHelper = DatabaseHelper();
                                    int? id = widget.transaction?.id;
                                    if (id != null) {
                                      dbHelper
                                          .deleteTransaction(id)
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Transaction deleted successfully')));
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.of(context)
                                            .pop(); // Close the AlertDialog
                                      });
                                    } else {
                                      Navigator.of(context)
                                          .pop(); // Close the AlertDialog
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.only(
                            top: 12.0,
                            bottom: 12.0,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.delete),
                          SizedBox(width: 10),
                          Text(
                            "Delete Transaction",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
