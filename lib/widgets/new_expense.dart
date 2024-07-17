import 'package:flutter/material.dart';
import 'package:expense_tracker/helper/date_time_formatter.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/rendering.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.newExpenseValues});

  final void Function(Expense) newExpenseValues;

  @override
  State<NewExpense> createState() {
    return _StateNewExpense();
  }
}

class _StateNewExpense extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year, now.month + 1, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final entreredAmount = double.tryParse(_amountController.text);

    String errors = '';
    bool errorFlag = false;
    if (entreredAmount == null || entreredAmount <= 0) {
      // show error message
      errors += "the Amount must be more than 0.0 \n";
      errorFlag = true;
    }

    if (_titleController.text.trim().isEmpty) {
      // show error message
      errors += "the Title can't be empty \n";
      errorFlag = true;
    }

    if (errorFlag) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Invaled input',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            errors,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    widget.newExpenseValues(
      Expense(
          title: _titleController.text,
          amount: entreredAmount!,
          date: _selectedDate ?? DateTime.now(),
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 30, 16, keyboardSpace + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  maxLines: 1,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$  ',
                          label: Text("Amount"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(formatter
                              .format(_selectedDate ?? DateTime.now())
                              .toString()),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = (value as Category);
                          });
                        }),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancle'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseData,
                      child: const Text("Save"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
