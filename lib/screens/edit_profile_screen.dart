import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minsta/resources/firestore_methods.dart';
import 'package:minsta/utils/colors.dart';
import 'package:minsta/utils/global_variables.dart';
import 'package:minsta/utils/utils.dart';
import 'package:minsta/widgets/text_field_input.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;
  const EditProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var userData = {};

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  late String bioHint;
  late String emailHint;
  late String firstNameHint;
  late String photoUrl;

  Uint8List? _image;
  bool _isLoading = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _firstNameController.dispose();
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  getData() async {
    _isLoading = true;
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      photoUrl = userData["photoUrl"];
      bioHint = userData["bio"];
      emailHint = userData["email"];
      firstNameHint = userData["firstName"];

      setState(() {});
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
    _isLoading = false;
  }

  updateUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_emailController.text != userData["email"] &&
        _emailController.text != "") {
      await FirestoreMethods().updateEmail(widget.uid, _emailController.text);
    }

    if (_bioController.text != userData["bio"] && _bioController.text != "") {
      await FirestoreMethods().updateBio(widget.uid, _bioController.text);
    }

    if (_firstNameController != userData["firstName"] &&
        _firstNameController.text != "") {
      await FirestoreMethods()
          .updateFirstName(widget.uid, _firstNameController.text);
    }

    if (_image != null) {
      await FirestoreMethods().updateProfilePicture(widget.uid, _image!);
    }

    setState(() {
      _isLoading = true;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          )
        : Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
            child: Scaffold(
              backgroundColor: width > webScreenSize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              appBar: AppBar(
                backgroundColor: width > webScreenSize
                    ? webBackgroundColor
                    : mobileBackgroundColor,
                title: const Text("edit profile"),
                centerTitle: false,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sizeBoxH24,
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 76,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : CircleAvatar(
                              radius: 76,
                              backgroundImage: NetworkImage(photoUrl),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      )
                    ],
                  ),
                  sizeBoxH36,
                  TextFieldInput(
                    textEditingController: _emailController,
                    hintText: emailHint,
                    textInputType: TextInputType.emailAddress,
                  ),
                  sizeBoxH24,
                  TextFieldInput(
                    textEditingController: _firstNameController,
                    hintText: firstNameHint,
                    textInputType: TextInputType.text,
                  ),
                  sizeBoxH24,
                  TextField(
                    controller: _bioController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: bioHint,
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                  sizeBoxH24,
                  InkWell(
                    onTap: () => updateUser(),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: blueColor,
                      ),
                      child: const Text("submit"),
                    ),
                  ),
                  sizeBoxH12,
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  sizeBoxH24,
                ],
              ),
            ),
          );
  }
}
