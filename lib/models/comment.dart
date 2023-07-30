import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String username;
  final String uid;
  final String photoUrl;
  final String text;
  final String commentId;
  final DateTime datePublished;
  final String postId;
  final likes;

  const Comment({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.text,
    required this.commentId,
    required this.datePublished,
    required this.postId,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "photoUrl": photoUrl,
        "text": text,
        "commentId": commentId,
        "datePublished": datePublished,
        "postId": postId,
        "likes": likes,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      username: snapshot["username"],
      uid: snapshot["uid"],
      photoUrl: snapshot["photoUrl"],
      text: snapshot["text"],
      commentId: snapshot["commentId"],
      datePublished: snapshot["datePublished"],
      postId: snapshot["postId"],
      likes: snapshot["likes"],
    );
  }
}
