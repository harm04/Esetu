// import 'package:esetu/model/usermodel.dart';
// import 'package:esetu/services/auth_services.dart';
// import 'package:flutter/widgets.dart';

// class UserProvider with ChangeNotifier {
//   UserModel? _user;
//   final AuthServices _authMethods = AuthServices();

//   UserModel get getUser => _user!;

//   Future<void> refreshUser() async {
//     UserModel user = await _authMethods.getUserDetails();  
//     _user = user;
//     notifyListeners();
//   }
// }


import 'package:esetu/model/usermodel.dart';
import 'package:esetu/services/auth_services.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthServices _authMethods = AuthServices();

  // Getter with null safety
  UserModel get getUser => _user!;

  // Refresh user details from the AuthServices
  Future<void> refreshUser() async {
    try {
      UserModel user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      print("Error refreshing user: $e");
    }
  }

  // Update user details using copyWith
  void updateUser({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? address,
    double? age,
    String? uid,
    String? type,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        address: address,
        age: age,
        uid: uid,
        type: type,
      );
      notifyListeners();
    }
  }
}
