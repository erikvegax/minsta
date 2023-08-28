import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
// import "package:minsta/screens/add_post_image_pick_screen.dart";
import "package:minsta/screens/add_post_pick_image_screen.dart";
import "package:minsta/screens/feed_screen.dart";
import "package:minsta/screens/profile_screen.dart";
import "package:minsta/screens/search_screen.dart";

const webScreenSize = 600;

const loading = Center(
  child: CircularProgressIndicator(),
);

List<Widget> homeScreenItems = [
  FeedScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  const SearchScreen(),
  const AddPostPickImageScreen(),
  Container(
    alignment: Alignment.center,
    child: const Text("todo"),
  ),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

const postsCollection = "posts";
const usersCollection = "users";
const commentsSubCollection = "comments";
const profilePicStorage = "profilePics";
