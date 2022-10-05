import 'package:DigiBus/database/user-db.dart';
import 'package:DigiBus/model/user.dart';

class FutureValues {
  /// Method to get the current [user] in the database using the
  /// [DatabaseHelper] class
  Future<User> getCurrentUser() async {
    var dbHelper = DatabaseHelper();
    Future<User> user = dbHelper.getUser();
    return user;
  }
}
