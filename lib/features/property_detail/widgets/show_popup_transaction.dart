import 'package:flutter/material.dart';
import 'package:project4_flutter/features/property_detail/property_detail.dart';

Future<void> showErrorDialogTransaction(
    BuildContext context, String message, String title) async {
  if (context.mounted) {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: title == "Error"
                  ? const TextStyle(color: Colors.red)
                  : const TextStyle(color: Colors.green)),
          content: Text(
            message,
            style: const TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const PropertyDetail()),
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
