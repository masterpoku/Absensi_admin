import 'package:d_method/d_method.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SourceAuth {
  static Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {
      } else {}
      DMethod.printTitle('FirebaseAuthException', e.code);
      return false;
    }
  }
}
