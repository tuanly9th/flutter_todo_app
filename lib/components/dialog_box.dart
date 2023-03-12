import 'package:flutter/material.dart';
import 'confirm_button.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox(
      {super.key,
      required this.controller,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[100],
      content: Container(
        height: double.tryParse(MediaQuery.of(context).orientation.toString()),
        width: double.tryParse(MediaQuery.of(context).orientation.toString()),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              // get user Input
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Add a new task',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConfirmButton(text: 'Save', onPressed: onSave),
              const SizedBox(
                width: 8,
              ),
              ConfirmButton(text: 'Cancel', onPressed: onCancel),
            ],
          )
        ]),
      ),
    );
  }
}
