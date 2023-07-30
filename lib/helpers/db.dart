import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await setDb();
    return _db!;
  }

  setDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cash_compass.db');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Transactions(id INTEGER PRIMARY KEY, currency TEXT, amount REAL, date TEXT, category TEXT, note TEXT, type TEXT)");
  }

  Future<int> saveTransaction(Transaction transaction) async {
    var dbClient = await db;
    int res = await dbClient.insert("Transactions", transaction.toMap());
    return res;
  }

  Future<List<Transaction>> getTransactions() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Transactions');
    List<Transaction> transactions = [];
    for (int i = 0; i < list.length; i++) {
      var transactionMap = Map<String, dynamic>.from(list[i]);
      transactions.add(Transaction.fromMap(transactionMap));
    }
    return transactions;
  }

  Future<int> deleteTransaction(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'Transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTransaction(Transaction transaction) async {
    var dbClient = await db;
    int res = await dbClient.update('Transactions', transaction.toMap(),
        where: 'id = ?', whereArgs: [transaction.id]);
    return res;
  }
}

class Transaction {
  int? id;
  String currency;
  double amount;
  String date;
  String category;
  String note;
  String type;

  Transaction({
    this.id,
    required this.currency,
    required this.amount,
    required this.date,
    required this.category,
    required this.note,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currency': currency,
      'amount': amount,
      'date': date,
      'category': category,
      'note': note,
      'type': type,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      currency: map['currency'],
      amount: map['amount'],
      date: map['date'],
      category: map['category'],
      note: map['note'],
      type: map['type'],
    );
  }
}
