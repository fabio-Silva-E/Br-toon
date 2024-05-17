import 'package:flutter/material.dart';
//import 'package:brasiltoon/src/config/custom_colors.dart';

class ShowOrderConfirmation {
  static Future<bool?> showOrderConfirmation(
      BuildContext context, String suffixText, String yes, String no) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmação'),
          content: Text(suffixText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(no),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(yes),
            ),
          ],
        );
      },
    );
  }
}
