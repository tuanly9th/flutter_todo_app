import 'package:flutter/material.dart';
import 'confirm_button.dart';

class ConfrimModal extends StatelessWidget {
  VoidCallback onConfirm;
  VoidCallback onCancel;

  ConfrimModal({super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[100],
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConfirmButton(text: 'OK', onPressed: onConfirm),
          const SizedBox(
            width: 8,
          ),
          ConfirmButton(text: 'Cancel', onPressed: onCancel),
        ],
      ),
    );
  }
}
