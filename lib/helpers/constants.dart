import 'package:flutter/material.dart';

String expensConstant = 'Expense';
String incomeConstant = 'Income';
const Color customColorPrimary = Colors.green;
const Color customDangerColor = Colors.red;

List expenseCategories = [
  {
    'name': 'Food',
    'icon': Icons.fastfood,
  },
  {
    'name': 'Transport',
    'icon': Icons.directions_car,
  },
  {
    'name': 'Shopping',
    'icon': Icons.shopping_bag,
  },
  {
    'name': 'Entertainment',
    'icon': Icons.movie,
  },
  {
    'name': 'Health',
    'icon': Icons.local_hospital,
  },
  {
    'name': 'Education',
    'icon': Icons.school,
  },
  {
    'name': 'Travel',
    'icon': Icons.flight,
  },
  {
    'name': 'Other',
    'icon': Icons.category,
  }
];

List incomeCategories = [
  {
    'name': 'Salary',
    'icon': Icons.work,
  },
  {
    'name': 'Business',
    'icon': Icons.business,
  },
  {
    'name': 'Gifts',
    'icon': Icons.card_giftcard,
  },
  {
    'name': 'Investments',
    'icon': Icons.attach_money,
  },
  {
    'name': 'Other',
    'icon': Icons.category,
  }
];

List transactionTypes = [
  {
    'name': incomeConstant,
    'icon': Icons.attach_money,
    'color': customColorPrimary,
    'categories': incomeCategories
  },
  {
    'name': expensConstant,
    'icon': Icons.shopping_cart,
    'color': customDangerColor,
    'categories': expenseCategories
  }
];

List currencies = [
  {'currency': 'INR', 'symbol': '₹'},
  {'currency': 'USD', 'symbol': '\$'},
  {'currency': 'EUR', 'symbol': '€'}
];
