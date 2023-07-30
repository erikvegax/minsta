import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:minsta/screens/add_post_screen.dart";
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
  const AddPostScreen(),
  const Text("notif"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];

const postsCollection = "posts";
const usersCollection = "users";
const commentsSubCollection = "comments";
const profilePicStorage = "profilePics";
