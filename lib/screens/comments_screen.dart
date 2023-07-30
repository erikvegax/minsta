import 'package:flutter/material.dart';
import 'package:minsta/resources/firestore_methods.dart';
import 'package:minsta/utils/colors.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:minsta/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minsta/models/user.dart';
import 'package:minsta/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        title: const Text("comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(postsCollection)
            .doc(widget.snap["postId"])
            .collection(commentsSubCollection)
            .orderBy(
              "datePublished",
              descending: false,
            )
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) => CommentCard(
                  snap: snapshot.data!.docs[index].data(),
                )),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "add a comment...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    widget.snap["postId"],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );

                  setState(() {
                    _commentController.clear();
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "post",
                    style: TextStyle(
                      color: blueColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
