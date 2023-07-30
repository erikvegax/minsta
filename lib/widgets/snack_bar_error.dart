import 'package:flutter/material.dart';

class ErrorSnackBar extends StatelessWidget {
  const ErrorSnackBar({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [],
    );
  }
}
