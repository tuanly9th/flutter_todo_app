import 'package:hive_flutter/hive_flutter.dart';

class TodoModel {
  // List<Map<String, dynamic>> _items = [];

  // final _shoppingBox = Hive.box('shopping_box');
  final _todoBox = Hive.box('todo_box');

  // get shoppingBox => _shoppingBox;

  List<Map<String, dynamic>> loadData() {
    // _shoppingBox.clear();
    // _shoppingBox

    final data = _todoBox.keys.map((key) {
      final value = _todoBox.get(key);
      // _todoBox.add(value);
      return {'key': key, 'title': value['title'], 'desc': value['desc'], 'assets' : value['assets'], 'isCompleted': value['isCompleted']};
    }).toList();

    return data.reversed.toList();
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _todoBox.add(newItem);
    loadData(); // update the UI
  }
}
