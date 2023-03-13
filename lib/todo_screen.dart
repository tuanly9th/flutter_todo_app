// main.dart
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'navigation/menu_draw.dart';
import 'navigation/menu_bottom.dart';
import 'models/todo_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Map<String, dynamic>> _items = [];

  final _todoBox = Hive.box('todo_box');
  TodoModel todoBox = TodoModel();

  @override
  void initState() {
    super.initState();
    _refreshItems(); // Load data when app starts
  }

  // Get all items from the database
  void _refreshItems() {
    setState(() {
      _items = todoBox.loadData();
    });
  }

  // Create new item
  void _createItem(Map<String, dynamic> newItem) {
    todoBox.createItem(newItem);
    _refreshItems();
  }

  // Retrieve a single item from the database by using its key
  // Our app won't use this function but I put it here for your reference
  // Map<String, dynamic> _readItem(int key) {
  //   final item = _shoppingBox.get(key);
  //   return item;
  // }

  // Update a single item
  void _updateItem(int itemKey, Map<String, dynamic> item) {
    todoBox.updateItem(itemKey, item);
    _refreshItems();
  }

  // Delete a single item
  Future<void> _deleteItem(int itemKey) async {
    await todoBox.deleteItem(itemKey);
    _refreshItems();

    // Display a snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  // TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['title'];
      _quantityController.text = existingItem['desc'];
    } else {
      _nameController.text = '';
      _quantityController.text = '';
    }

    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                          child: const Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      itemKey != null
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                _deleteItem(itemKey);
                                Navigator.pop(context);
                              },
                            )
                          : Column(),
                    ],
                  ),
                  TextField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(hintText: 'Input something'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.multiline,
                    minLines: 6,
                    maxLines: 12,
                    decoration: InputDecoration(
                        hintText: 'Description',
                        border: InputBorder.none,
                        fillColor: Colors.yellow.shade100),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        _createItem({
                          'title': _nameController.text,
                          'desc': _quantityController.text,
                        });
                      }

                      // update an existing item
                      if (itemKey != null) {
                        _updateItem(itemKey, {
                          'title': _nameController.text.trim(),
                          'desc': _quantityController.text.trim()
                        });
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _quantityController.text = '';

                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
      ),
      drawer: const MenuDrawer(),
      bottomNavigationBar: const MenuBottom(),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              // the list of items
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];
                return Card(
                  color: currentItem['isCompleted']
                      ? const Color.fromARGB(255, 130, 175, 4)
                      : Colors.orange.shade50,
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        value: currentItem['isCompleted'],
                        onChanged: (value) {
                          final tmp = currentItem;
                          tmp['isCompleted'] = value;
                          _updateItem(currentItem['key'], {...tmp});
                        },
                        title: Text(
                          currentItem['title'],
                          style: TextStyle(
                            decoration: currentItem['isCompleted'] ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          currentItem['desc'],
                          style: TextStyle(
                            decoration: currentItem['isCompleted'] ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        secondary: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                                icon: const Icon(Icons.edit),
                                iconSize: 24,
                                onPressed: () =>
                                    _showForm(context, currentItem['key'])),
                            // Delete button
                            // IconButton(
                            //   icon: const Icon(Icons.delete),
                            //   onPressed: () => _deleteItem(currentItem['key']),
                            // ),
                          ],
                        ),
                      ),
                      // ListTile(
                      //   title: Text(currentItem['title']),
                      //   subtitle: Text(currentItem['desc'].toString().length >
                      //           150
                      //       ? '${currentItem['desc'].toString().substring(0, 150)}...'
                      //       : currentItem['desc'].toString()),
                      //   trailing: Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     children: [
                      //       // Edit button
                      //       // IconButton(
                      //       //     icon: const Icon(Icons.edit),
                      //       //     onPressed: () =>
                      //       //         _showForm(context, currentItem['key'])),
                      //       // Delete button
                      //       IconButton(
                      //         icon: const Icon(Icons.delete),
                      //         onPressed: () => _deleteItem(currentItem['key']),
                      //       ),
                      //     ],
                      //   ),
                      //   onTap: () {
                      //     print('tab press list');
                      //     _showForm(context, currentItem['key']);
                      //   },
                      // ),
                    ],
                  ),
                );
              }),
      // Add new item button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
