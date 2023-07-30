import 'package:cash_compass/helpers/constants.dart';
import 'package:cash_compass/helpers/db.dart';

List<DateTime> getMonths() {
  List<DateTime> months = [];
  DateTime current = DateTime.now();

  for (var i = 0; i < 24; i++) {
    months.add(DateTime(current.year, current.month - i));
  }

  return months.reversed.toList();
}

Map<String, List<Transaction>> groupTransactionsByDate(
    List<Transaction> transactions) {
  Map<String, List<Transaction>> groupedTransactions = {};

  for (var transaction in transactions) {
    if (!groupedTransactions.containsKey(transaction.date)) {
      groupedTransactions[transaction.date] = [];
    }
    groupedTransactions[transaction.date]!.add(transaction);
  }

  return groupedTransactions;
}

class CurrencyTransactions {
  final String currency;
  final List<Transaction> income;
  final List<Transaction> expense;

  CurrencyTransactions(
      {required this.currency, required this.income, required this.expense});
}

List<CurrencyTransactions> groupTransactionsByCurrency(
    List<Transaction> transactions) {
  List<String> allCurrencies = [];

  for (var transaction in transactions) {
    if (!allCurrencies.contains(transaction.currency)) {
      allCurrencies.add(transaction.currency);
    }
  }

  return allCurrencies.map((currency) {
    var income = transactions
        .where((transaction) =>
            transaction.type == incomeConstant &&
            transaction.currency == currency)
        .toList();
    var expense = transactions
        .where((transaction) =>
            transaction.type == expensConstant &&
            transaction.currency == currency)
        .toList();
    return CurrencyTransactions(
        currency: currency, income: income, expense: expense);
  }).toList();
}
