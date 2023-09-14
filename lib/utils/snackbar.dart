import 'package:flutter/material.dart';

import '../view/widgets/custom_text.dart';

void openSnackbar(context, snackMessage, color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      ),
      content: CustomTextWidget(
        style: const TextStyle(fontSize: 14),
        text: snackMessage,
      ),
    ),
  );
}
