// main.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';
// import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  List<Widget> imagesUpload = [];
  List<Widget> imagesTmp = [];

  TodoModel todoBox = TodoModel();

  @override
  void initState() {
    super.initState();
    // todoBox.loadData();
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
    // ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('An item has been deleted')));
  }

  Future<void> _pickerFile(Function setState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        dialogTitle: 'Upload files',
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'doc', 'docx', 'pdf']);

    // List<Widget> imagesTmp = [];
    if (result != null) {
      for (PlatformFile file in result.files) {
        // Uint8List blobUrl = base64Decode(file.path.toString());
        List arr = file.path.toString().split('.');
        List arr2 = file.path.toString().split('\\');
        // print(['jpg', 'png'].indexOf(arr.last));
        // final ext = extension();
        print(arr2);
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        print((documentDirectory.path + '\\flutter_demo\\' + arr2.last));
        File(documentDirectory.path + '\\flutter_demo\\' + arr2.last)
            .create(recursive: true)
            .then((File file22) {
          file22.writeAsBytes(File(file.path.toString()).readAsBytesSync());
        });
        setState(() {
          if (['jpg', 'png'].contains(arr.last)) {
            print(MediaQuery.of(context).size.width);
            imagesUpload.add(Container(
              padding: const EdgeInsets.all(12),
              child: Container(
                // width: MediaQuery.of(context).size.width,
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(file.path.toString())),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                // child: Image(
                //   image: FileImage(File(file.path.toString())),
                //   filterQuality: FilterQuality.high,
                //   width: MediaQuery.of(context).devicePixelRatio,
                // ),
              ),
            ));

// file.writeAsBytesSync(response.bodyBytes);
          }
          // print(imagesTmp);
        });
      }
    }
  }

  // TextFields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(BuildContext context, int? itemKey) async {
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
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.blueGrey.shade100,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return ListView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 15,
                    left: 15,
                    right: 15),
                children: [
                  Column(
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
                          Row(
                            children: [
                              ElevatedButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(16)),
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

                                  Navigator.of(context)
                                      .pop(); // Close the bottom sheet
                                },
                                child: Text(
                                    itemKey == null ? 'Create New' : 'Update'),
                              ),
                              const SizedBox(width: 12),
                              itemKey != null
                                  ? IconButton(
                                      icon: const Icon(Icons.delete),
                                      splashRadius: 24,
                                      splashColor: Colors.black12,
                                      hoverColor: Colors.blueGrey.shade100,
                                      color: Colors.red,
                                      onPressed: () {
                                        _deleteItem(itemKey);
                                        Navigator.pop(context);
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                        decoration: InputDecoration(
                            // hintText: 'Title',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.yellow.shade100,
                            labelText: ('Title'),
                            labelStyle: const TextStyle(fontSize: 12)),
                      ),
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.multiline,
                        minLines: 6,
                        maxLines: null,
                        decoration: InputDecoration(
                            // hintText: 'Description',
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.yellow.shade50,
                            labelText: ('Description'),
                            labelStyle: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          child: imagesUpload.isEmpty
                              ? Container()
                              : Row(
                                  children: imagesUpload,
                                )
                          // : ListView.builder(
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: imagesTmp.length,
                          //     itemBuilder: (_, index) {
                          //       print(imagesTmp[index]);
                          //       // return Text('data$index');
                          //       return Image(
                          //         image: FileImage(imagesTmp[index]),
                          //         width: 200,
                          //       );
                          //     }),
                          ),
                      ElevatedButton(
                        onPressed: () {
                          _pickerFile(setModalState);
                          // setModalState(() {
                          //   imagesUpload = [...imagesTmp];
                          // });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.attach_file),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  )
                ],
              );
            }));
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
                final desc = currentItem['desc'].toString().length > 150
                    ? '${currentItem['desc'].toString().substring(0, 150)}...'
                    : currentItem['desc'];
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
                            fontWeight: FontWeight.bold,
                            decoration: currentItem['isCompleted']
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(
                          desc,
                          style: TextStyle(
                            decoration: currentItem['isCompleted']
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        secondary: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                                icon: const Icon(Icons.edit),
                                iconSize: 24,
                                onPressed: () {
                                  _showForm(context, currentItem['key']);
                                  print(getApplicationDocumentsDirectory());
                                }),
                          ],
                        ),
                      ),
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
