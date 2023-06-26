import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key,});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 20,
      date: DateTime.now(),
      category: Category.education
    ),
    Expense(
      title: 'Cinema',
      amount: 15,
      date: DateTime.now(),
      category: Category.entertainment
    ),
  ];

  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text('${expense.title} removed.'),
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
      )
    ));
  }

  double getTotalExpenses() {
    double total = 0;
    for (var expense in _registeredExpenses) {
      total += expense.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

  if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Track.it'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width<600 
        ? Column(
          children: [
          Chart(expenses: _registeredExpenses),
          Text('Total Expenses: ₹${getTotalExpenses().toStringAsFixed(2)}'),
          Expanded(
            child : mainContent,
          ),
        ])
        : Row(
          children: [
          Expanded(
            child:Column(
              children:[
                Chart(expenses: _registeredExpenses),
                Text('Total Expenses: ₹${getTotalExpenses().toStringAsFixed(2)}'),
                ])
          ),
          Expanded(
            child : mainContent,
          ),
        ])
    );
  }
}