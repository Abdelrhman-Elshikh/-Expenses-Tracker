import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expend, {super.key});

  final Expense expend;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Text(expend.title),
            Row(
              children: [
                Text('\$${expend.amount.toString()}'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcon[expend.category]),
                    Text(expend.formattedDate.toString()),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
