import 'package:hive_flutter/hive_flutter.dart';

class TodoModel {
  final _todoBox = Hive.box('todo_box');

  List<Map<String, dynamic>> loadData() {
    final data = _todoBox.keys.map((key) {
      final value = _todoBox.get(key);
      // _todoBox.put(key, {...value, 'isCompleted': false});
      return {
        'key': key,
        'title': value['title'],
        'desc': value['desc'],
        'assets': value['assets'],
        'isCompleted': value['isCompleted'],
        'comments': value['comments']
      };
    }).toList();

    return data.reversed.toList();
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    newItem['isCompleted'] = false;
    newItem['comment'] = [];
    newItem['assets'] = newItem['assets'] ?? [];
    await _todoBox.add(newItem);
    loadData(); // update the UI
  }

  Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await _todoBox.put(itemKey, {..._todoBox.get(itemKey), ...item});
  }

  Future<void> updateItemComment(int itemKey, String comment) async {
    var item = _todoBox.get(itemKey);
    List<dynamic> tmpComment = item['comments'] ?? [];
    tmpComment.add(comment);
    await _todoBox.put(itemKey, {...item, 'comments': tmpComment});
  }
  Future<void> deleteComment(int itemKey,String comment) async {
    var item = _todoBox.get(itemKey);
    List<dynamic> tmpComment = item['comments'] ?? [];
    // tmpComment.removeAt(index);
    tmpComment.remove(comment);
    await _todoBox.put(itemKey, {...item, 'comments': tmpComment});
  }

  Future<void> deleteItem(int itemKey) async {
    await _todoBox.delete(itemKey);
  }
}
