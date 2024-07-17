import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'flutter',
        amount: 10.9,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'cima',
        amount: 22.9,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Alex',
        amount: 50.9,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: 'lunch',
        amount: 22.9,
        date: DateTime.now(),
        category: Category.food)
  ];

  void _overLay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        newExpenseValues: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
        content: const Text('Expense Deleted'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget? childWidget;

    if (_registeredExpenses.isEmpty) {
      childWidget = const Center(
        child: Text(
          "There are no expenses yet!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
    } else {
      childWidget = ExpensesList(
        expensesList: _registeredExpenses,
        removeExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Flutter Expenses Tracker"),
            const Spacer(),
            IconButton(
                onPressed: _overLay,
                icon: const Icon(Icons.add),
                color: Colors.greenAccent),
          ],
        ),
      ),
      body: width < height
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: childWidget),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                Expanded(child: childWidget),
              ],
            ),
    );
  }
}
