import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

export 'package:provider/provider.dart';

abstract class HospitalAuthBase {
  User get currentUser;

  Stream<User> authStateChanges();

  Future<void> signOut();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(
      String email, String password, String prn, String name);
}

class HospitalAuth implements HospitalAuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password, String prn, String name) async {
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection("Hospitals")
        .doc(userCredential.user.uid)
        .set(
      {
        "hospital_email": email,
        "hospital_name": name,
        "hospital_number": prn,
      },
    );
  }
}
