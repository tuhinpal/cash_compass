import 'package:cash_compass/components/transaction/render_income_expense.dart';
import 'package:cash_compass/helpers/constants.dart';
import 'package:cash_compass/helpers/db.dart';
import 'package:cash_compass/helpers/transaction_helpers.dart';
import 'package:cash_compass/screens/crud_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    var dbHelper = DatabaseHelper();
    transactions = await dbHelper.getTransactions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final months = getMonths();

    return DefaultTabController(
      length: months.length,
      initialIndex: months.length - 1,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 25.0,
                width: 25.0,
              ),
              const SizedBox(width: 8.0),
              const Text('CashCompass',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: const Color(0xFF00d72e),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: months.map((month) {
              // Formats the date as "Month Year"
              String monthYear = DateFormat('MMMM yyyy').format(month);
              return Tab(text: monthYear.toUpperCase());
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: months.map((month) {
            // Get the transactions for the month
            List<Transaction> monthTransactions =
                transactions.where((transaction) {
              DateTime transactionDate = DateTime.parse(transaction.date);
              return transactionDate.month == month.month &&
                  transactionDate.year == month.year;
            }).toList();

            // if there are no transactions for the month, render a message
            if (monthTransactions.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No transactions for this month',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Start adding transactions by clicking the +',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            }

            // Group transactions by date
            Map<String, List<Transaction>> groupedTransactions =
                groupTransactionsByDate(monthTransactions);

            return ListView.builder(
              itemCount: groupedTransactions.length + 1,
              padding: const EdgeInsets.only(
                top: 12,
              ),
              itemBuilder: (BuildContext context, int index) {
                // Render total income and expense in the first row
                if (index == 0) {
                  return RenderIncomeExpense(transactions: monthTransactions);
                }

                String date = groupedTransactions.keys.elementAt(index - 1);
                List<Transaction> transactionsForDate =
                    groupedTransactions[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.0, // 100% of the width
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 12,
                          bottom: 4,
                        ),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            DateFormat('d MMMM yyyy')
                                .format(DateTime.parse(date)),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // txns
                    ...transactionsForDate.map((transaction) {
                      Color color = transaction.type == incomeConstant
                          ? Colors.green
                          : Colors.red;

                      String currencySymbol = currencies.firstWhere(
                        (element) =>
                            element['currency'] == transaction.currency,
                        orElse: () => {'symbol': transaction.currency},
                      )['symbol'];

                      IconData icon = (transactionTypes.firstWhere(
                        (element) => element['name'] == transaction.type,
                      )['categories'] as List)
                          .firstWhere(
                        (element) => element['name'] == transaction.category,
                        orElse: () => {'icon': Icons.category},
                      )['icon'];

                      return ListTile(
                        leading: Icon(icon, color: color, size: 36.0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.category,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0)),

                            // If the transaction has a note, render it
                            if (transaction.note != '')
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  transaction.note,
                                  style: const TextStyle(fontSize: 14.0),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
                          '$currencySymbol ${transaction.amount}',
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        onTap: () {
                          // your tap handling logic here, for example:
                          debugPrint('Transaction ${transaction.id} tapped');
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => CrudTransaction(
                                transaction: transaction,
                              ),
                            ),
                          )
                              .then((_) {
                            // Fetch the transactions again after returning from the CrudTransaction page
                            fetchTransactions();
                          });
                        },
                      );
                    }).toList(),
                  ],
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => const CrudTransaction(),
              ),
            )
                .then((_) {
              // Fetch the transactions again after returning from the CrudTransaction page
              fetchTransactions();
            });
          },
          backgroundColor: const Color(0xFF00d72e),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
