import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esetu/model/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('Users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<String> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    String res = 'some error occurred';
    try {
       
        UserCredential _cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserModel userModel = UserModel(
          type: 'user',
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          address: '',
          age: 0,
          uid: _cred.user!.uid,
        );
        await _firestore
            .collection('Users')
            .doc(_cred.user!.uid)
            .set(userModel.toJson());
        res = "success";
    
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> login(
      {required String email, required String password}) async {
    String res = 'something went wrong';
    try {
     
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
    
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logout() async {
    String res = 'something went wrong';
    try {
      await _auth.signOut();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
