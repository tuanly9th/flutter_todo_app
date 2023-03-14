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
  List<String> imagesUploaded = [];
  List<String> imagesPath = [];
  static const String folder = 'flutter_demo';

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
    saveFilesToFolder();
    imagesPath = [];
    _refreshItems();
  }

  // Update a single item
  void _updateItem(int itemKey, Map<String, dynamic> item) {
    todoBox.updateItem(itemKey, item);
    saveFilesToFolder();
    imagesPath = [];
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

  void saveFilesToFolder() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    for (String path in imagesPath) {
      List splitNameList = path.split('\\');
      File('${documentDirectory.path}\\$folder\\${splitNameList.last}')
          .create(recursive: true)
          .then((File value) {
        value.writeAsBytes(File(path.toString()).readAsBytesSync());
      });
    }
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
        // print(arr2);
        // Directory documentDirectory = await getApplicationDocumentsDirectory();
        // print((documentDirectory.path + '\\flutter_demo\\' + arr2.last));
        // File(documentDirectory.path + '\\flutter_demo\\' + arr2.last)
        //     .create(recursive: true)
        //     .then((File file22) {
        //   file22.writeAsBytes(File(file.path.toString()).readAsBytesSync());
        // });
        setState(() {
          if (['jpg', 'png'].contains(arr.last)) {
            print(MediaQuery.of(context).size.width);
            imagesPath.add(file.path.toString());
            // imagesUploaded.add(Container(
            //   padding: const EdgeInsets.all(12),
            //   child: Container(
            //     // width: MediaQuery.of(context).size.width,
            //     width: 80,
            //     height: 60,
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //           image: FileImage(File(file.path.toString())),
            //           fit: BoxFit.cover,
            //         ),
            //         borderRadius: const BorderRadius.all(Radius.circular(12))),
            //     child: ElevatedButton(
            //       style: const ButtonStyle(
            //           backgroundColor:
            //               MaterialStatePropertyAll(Colors.transparent)),
            //       onPressed: () {},
            //       child: Text(
            //         arr2.last.toString().length > 15
            //             ? arr2.last.toString().substring(
            //                 arr2.last.toString().length - 15,
            //                 arr2.last.toString().length)
            //             : arr2.last.toString(),
            //         style: const TextStyle(fontSize: 8),
            //       ),
            //     ),
            //   ),
            // ));

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
    print('object');
    print(MediaQuery.of(context).size.width);
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['title'];
      _quantityController.text = existingItem['desc'];
      setState(() {
        imagesUploaded = existingItem['assets'] ?? [];
      });
    } else {
      _nameController.text = '';
      _quantityController.text = '';
      setState(() {
        imagesPath = [];
        imagesUploaded = [];
      });
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.blueGrey.shade100,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Stack(
                fit: StackFit.loose,
                children: [
                  ListView(
                    padding: const EdgeInsets.only(
                        // bottom: MediaQuery.of(context).viewInsets.bottom,
                        bottom: 100,
                        top: 60,
                        left: 15,
                        right: 15),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // const SizedBox(height: 24),
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
                              width: MediaQuery.of(context).size.width,
                              // height: 400,
                              padding: const EdgeInsets.all(20),
                              child: Wrap(
                                  // scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    for (var path in [
                                      ...imagesUploaded,
                                      ...imagesPath
                                    ])
                                      Container(
                                        // width: MediaQuery.of(context).size.width,
                                        margin: const EdgeInsets.all(12),
                                        width: 80,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(File(path)),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12))),
                                        child: ElevatedButton(
                                          style: const ButtonStyle(
                                              shadowColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.transparent),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.transparent)),
                                          onPressed: () {},
                                          child: const Text(
                                            'Hello',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                      ),
                                  ])),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     _pickerFile(setModalState);
                          //   },
                          //   child: const Padding(
                          //     padding: EdgeInsets.all(5),
                          //     child: Icon(Icons.attach_file),
                          //   ),
                          // ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.all(5.0),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.blue.withAlpha(255),
                          Colors.blue.shade100
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FloatingActionButton(
                            mini: true,
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
                                    'assets': [...imagesUploaded, ...imagesPath]
                                  });
                                }

                                // update an existing item
                                if (itemKey != null) {
                                  _updateItem(itemKey, {
                                    'title': _nameController.text.trim(),
                                    'desc': _quantityController.text.trim(),
                                    'assets': [...imagesUploaded, ...imagesPath]
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
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    // width: 100,
                    // width: double.infinity,
                    child: Container(
                      height: 100,
                      decoration:
                          BoxDecoration(color: Colors.lightGreen.shade300),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            flex: 4,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen.shade900,
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                    // hintText: 'Description',
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.yellow.shade50,
                                    labelText: ('Comment'),
                                    labelStyle: const TextStyle(fontSize: 12)),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.lime.shade900,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _pickerFile(setModalState);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(Icons.attach_file),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
