import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minsta/utils/colors.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:minsta/widgets/post_card.dart';
import 'package:minsta/utils/utils.dart';

class FeedScreen extends StatefulWidget {
  final String uid;
  const FeedScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  var userData = {};
  late List following;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      following = userData["following"];
      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? loading
        : Scaffold(
            backgroundColor: width > webScreenSize
                ? webBackgroundColor
                : mobileBackgroundColor,
            appBar: width > webScreenSize
                ? null
                : AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: mobileBackgroundColor,
                    centerTitle: false,
                    title: SvgPicture.asset(
                      "assets/ic_instagram.svg",
                      color: primaryColor,
                      height: 32,
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.messenger_outline),
                      ),
                    ],
                  ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(postsCollection)
                  .where("uid", isNotEqualTo: widget.uid)
                  .where("uid", whereIn: following)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return snapshot.data!.docs.isEmpty
                    ? const Center(
                        child: Text(
                          "nothing to show here. start following more people!",
                        ),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width > webScreenSize ? width * 0.3 : 0,
                          ),
                          child: PostCard(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        ),
                      );
              },
            ),
          );
  }
}
