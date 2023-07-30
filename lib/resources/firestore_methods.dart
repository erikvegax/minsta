import 'dart:typed_data';
import 'package:minsta/models/comment.dart';
import 'package:minsta/resources/auth_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minsta/models/post.dart';
import 'package:minsta/resources/storage_methods.dart';
import 'package:minsta/utils/global_variables.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description, uid, username, profileImage, Uint8List file) async {
    String res = "error during post upload";
    try {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage(postsCollection, file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        photoUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection(postsCollection).doc(postId).set(
            post.toJson(),
          );
      res = success;
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection(postsCollection).doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        return;
      }

      await _firestore.collection(postsCollection).doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });

      likes.add(uid);
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> postComment(String postId, String text, String uid,
      String username, String photoUrl) async {
    try {
      if (text.isEmpty) {
        print("cannot leave an empty comment");
      }

      String commentId = const Uuid().v1();
      Comment comment = Comment(
        photoUrl: photoUrl,
        username: username,
        uid: uid,
        text: text,
        commentId: commentId,
        datePublished: DateTime.now(),
        postId: postId,
        likes: [],
      );

      await _firestore
          .collection(postsCollection)
          .doc(postId)
          .collection(commentsSubCollection)
          .doc(commentId)
          .set(
            comment.toJson(),
          );
    } catch (err) {
      print("uid $uid");
      print(
        err.toString(),
      );
    }
  }

  Future<void> likeComment(
      String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection(postsCollection)
            .doc(postId)
            .collection(commentsSubCollection)
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
        return;
      }

      await _firestore
          .collection(postsCollection)
          .doc(postId)
          .collection(commentsSubCollection)
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });

      likes.add(uid);
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection(postsCollection).doc(postId).delete();
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
