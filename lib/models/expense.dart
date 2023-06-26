import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category {
  food,
  entertainment,
  transportation,
  utilities,
  clothing,
  insurance,
  health,
  personal,
  education,
  gifts,
  other
}

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.entertainment: Icons.movie,
  Category.transportation: Icons.directions_car,
  Category.utilities: Icons.lightbulb_outline,
  Category.clothing: Icons.shopping_basket,
  Category.insurance: Icons.verified_user,
  Category.health: Icons.local_hospital,
  Category.personal: Icons.person,
  Category.education: Icons.school,
  Category.gifts: Icons.card_giftcard,
  Category.other: Icons.attach_money
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category) 
  : expenses = allExpenses
    .where((expense) => expense.category == category)
    .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses{
    double sum = 0;

    for(final expense in expenses){
      sum += expense.amount;
    }

    return sum;
  }
}