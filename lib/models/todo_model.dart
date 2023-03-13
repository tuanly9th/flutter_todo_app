import 'package:hive_flutter/hive_flutter.dart';

class TodoModel {

  final _todoBox = Hive.box('todo_box');

  List<Map<String, dynamic>> loadData() {

    final data = _todoBox.keys.map((key) {
      final value = _todoBox.get(key);
      return {'key': key, 'title': value['title'], 'desc': value['desc'], 'assets' : value['assets'], 'isCompleted': value['isCompleted']};
    }).toList();

    return data.reversed.toList();
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    newItem['isCompleted'] = false;
    await _todoBox.add(newItem);
    loadData(); // update the UI
  }

   Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await _todoBox.put(itemKey, item);
  }

  Future<void> deleteItem(int itemKey) async {
    await _todoBox.delete(itemKey);
  }
}
