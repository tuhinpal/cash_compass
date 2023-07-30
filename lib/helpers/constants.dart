import 'package:flutter/material.dart';

String expensConstant = 'Expense';
String incomeConstant = 'Income';
const Color customColorPrimary = Color(0xFF00e600);
const Color customDangerColor = Color(0xFFFF0000);

MaterialColor customSwatch = const MaterialColor(
  0xFF00e600,
  <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(0xFF00e600),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  },
);

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
    'name': expensConstant,
    'icon': Icons.shopping_cart,
    'color': customDangerColor,
    'categories': expenseCategories
  },
  {
    'name': incomeConstant,
    'icon': Icons.attach_money,
    'color': customColorPrimary,
    'categories': incomeCategories
  }
];

List currencies = [
  {'currency': 'INR', 'symbol': '₹'},
  {'currency': 'USD', 'symbol': '\$'},
  {'currency': 'EUR', 'symbol': '€'}
];
