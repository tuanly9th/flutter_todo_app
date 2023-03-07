import 'package:flutter/material.dart';

class ToDoTileV2 extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?) onChanged;
  Function deleteTask;
  ToDoTileV2(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.onChanged,
      required this.deleteTask});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Container(
        padding: const EdgeInsets.only(left: 24, top: 14, bottom: 14, right: 8),
        decoration: BoxDecoration(
            color: Colors.yellow[600], borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                // checkbox
                Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.pinkAccent,
                ),
                // task name
                Text(
                  taskName,
                  style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ],
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              onPressed: () => deleteTask(),
              child: const Icon(
                Icons.delete,
                semanticLabel: 'Delete',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
