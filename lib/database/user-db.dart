import 'dart:async';
import 'dart:io' as io;

import 'package:DigiBus/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// This creates and controls a sql-lite database for the logged in user's details
class DatabaseHelper {
  /// Instantiating this class to make it a singleton
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  /// Instantiating database from the sql-lite package
  static Database _db;

  /// A string value to hold the name of the table in the database
  final String USER_TABLE = "User";

  /// A function to get the database [_db] if it exists or wait to initialize
  /// a new database by calling [initDb()] and return [_db]
  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  /// Creating a new database in the device located in [path] with the
  /// [_onCreate()] function to create its table and fields
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "user.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  /// Function to execute sql-lite statement to create a new table and its fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
      "CREATE TABLE $USER_TABLE("
      "userID TEXT PRIMARY KEY NOT NULL,"
      "fullName TEXT NOT NULL,"
      "walletBalance TEXT NOT NULL,"
      "email TEXT NOT NULL)",
    );
    print("Created tables");
  }

  /// This function insert user's details into the database records
  Future<int> saveUser(User user) async {
    await deleteUsers();
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  /// This function get user's details from the database
  Future<User> getUser() async {
    var dbConnection = await db;
    List<Map> users = await dbConnection.rawQuery('SELECT * FROM $USER_TABLE');
    User userVal;
    for (int i = 0; i < users.length; i++) {
      User user = new User(
        users[0]['userID'],
        users[0]['fullName'],
        users[0]['email'],
        users[0]['walletBalance'],
      );
      userVal = user;
    }
    return userVal;
  }

  updateWalletBalance(String walletBalance, String userID) async {
    final dbClient = await db;
    await dbClient.rawUpdate(
      'UPDATE user SET walletBalance = ? WHERE userID = ?',
      [walletBalance, userID],
    );
  }

  /// This function deletes user's details from the database records
  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  /// This function checks if a user exists in the database by querying the
  /// database to check the length of the records and returns true if it is > 0
  /// or false if it is not
  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query(USER_TABLE);
    return res.length > 0 ? true : false;
  }
}
