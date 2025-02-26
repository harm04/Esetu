// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   final String email;
//   final String password;
//   final String firstName;
//   final String lastName;
//   final String uid;
//   final double age;
//   final String? address;

//   final String type;

//   UserModel(
//       {required this.email,
//       required this.password,
//       required this.firstName,
//       required this.lastName,
//       // required this.phone,

//       required this.address,
//       required this.age,
//       required this.uid,
//       required this.type});

//   Map<String, dynamic> toJson() => {
//         'email': email,
//         'password': password,
//         'firstName': firstName,
//         'lastName': lastName,
//         'uid': uid,
//         'age': age,
//         'address': address,
//         'type': type,
//       };

//   static UserModel fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//     return UserModel(
//         email: snapshot['email'],
//         age: snapshot['age'],
//         password: snapshot['password'],
//         firstName: snapshot['firstName'],
//         lastName: snapshot['lastName'],

//         // phone: snapshot['phone'],
//         address: snapshot['address'] ?? "",
//         type: snapshot['type'],
//         uid: snapshot['uid']);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String uid;
  final double age;
  final String? address;
  final String type;

  UserModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.age,
    required this.uid,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'uid': uid,
        'age': age,
        'address': address,
        'type': type,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'],
      age: snapshot['age'],
      password: snapshot['password'],
      firstName: snapshot['firstName'],
      lastName: snapshot['lastName'],
      address: snapshot['address'] ?? "",
      type: snapshot['type'],
      uid: snapshot['uid'],
    );
  }

  // Adding the copyWith method
  UserModel copyWith({
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? address,
    double? age,
    String? uid,
    String? type,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      age: age ?? this.age,
      uid: uid ?? this.uid,
      type: type ?? this.type,
    );
  }
}
