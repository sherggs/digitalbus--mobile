/// A class to hold my [User] model
class User {
  /// This variable holds the user id
  String _userID;

  /// This variable holds the user name
  String _fullName;

  /// This variable holds the user email address
  String _email;

  /// This variable holds the user walletBalance
  String _walletBalance;

  /// Setting constructor for [User] class
  User(
    this._userID,
    this._fullName,
    this._email,
    this._walletBalance,
  );

  /// Creating getters for my [_userID] value
  String get userID => _userID;

  /// Creating getters for my [_fullName] value
  String get firstName => _fullName;

  /// Creating getters for my [_email] value
  String get email => _email;

  /// Creating getters for my [_email] value
  String get walletBalance => _walletBalance;

  /// Function to map user's details from a JSON object
  User.map(dynamic obj) {
    this._userID = obj["userID"];
    this._fullName = obj["fullName"];
    this._email = obj["email"];
    this._walletBalance = obj["walletBalance"];
  }

  /// Function to map user's details to a JSON object
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["userID"] = _userID;
    map["fullName"] = _fullName;
    map["email"] = _email;
    map["walletBalance"] = _walletBalance;
    return map;
  }
}
