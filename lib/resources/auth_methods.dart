import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minsta/models/user.dart' as model;
import 'package:minsta/resources/storage_methods.dart';
import 'package:minsta/utils/global_variables.dart';

const String success = "success";

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required String firstName,
    required Uint8List file,
  }) async {
    String res = "error during sign up";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          firstName.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage(profilePicStorage, file, false);

        model.User user = model.User(
          username: username,
          email: email,
          bio: bio,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          firstName: firstName,
          following: [],
          followers: [],
        );

        await _firestore
            .collection(usersCollection)
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = success;
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res = "the email you've provided is invalid.";
      }
      if (err.code == "weak-password") {
        res = "your password should be at least 6 characters.";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = "error during login";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = success;
      } else {
        res = "email and password required to log in";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection(usersCollection).doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
