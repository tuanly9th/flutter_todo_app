import 'package:hive_flutter/hive_flutter.dart';

class TodoDataBase {

  List todoList = [];
  /* reference the box */
  final _todoBox = Hive.box('todoBox');

  void createInitial() {
    todoList = [
      ['Make turtorial', false],
      ['Do something', false],
    ];
  }

  void loadData() {
    todoList = _todoBox.get('TodoList');
  }
  void updateData() {
    _todoBox.put('TodoList', todoList);
  }
}