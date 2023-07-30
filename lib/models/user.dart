import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String bio;
  final String uid;
  final String photoUrl;
  final String firstName;
  final List following;
  final List followers;

  const User({
    required this.username,
    required this.email,
    required this.bio,
    required this.uid,
    required this.photoUrl,
    required this.firstName,
    required this.following,
    required this.followers,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "bio": bio,
        "uid": uid,
        "photoUrl": photoUrl,
        "firstName": firstName,
        "following": following,
        "followers": followers,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        email: snapshot["email"],
        bio: snapshot["bio"],
        uid: snapshot["uid"],
        photoUrl: snapshot["photoUrl"],
        firstName: snapshot["firstName"],
        following: snapshot["following"],
        followers: snapshot["followers"]);
  }
}
