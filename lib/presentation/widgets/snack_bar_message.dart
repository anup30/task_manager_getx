import 'package:flutter/material.dart';

void showSnackBarMessage(BuildContext context, String msg,
    [bool isErrorMessage = false]) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: isErrorMessage ? Colors.red : null,
    ),
  );
}

//@34:42
