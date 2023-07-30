import "package:flutter/material.dart";
import "package:minsta/providers/user_provider.dart";
import 'package:minsta/utils/global_variables.dart';
import "package:provider/provider.dart";

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    addData();
    setState(() {
      isLoading = false;
    });
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loading
        : LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > webScreenSize) {
                return widget.webScreenLayout;
              }
              return widget.mobileScreenLayout;
            },
          );
  }
}
