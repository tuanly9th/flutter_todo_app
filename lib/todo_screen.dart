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

  void _saveComment(int itemKey, Function setState) {
    // print('text comment');
    // print(_commentController.text);
    if (_commentController.text != '') {
      todoBox.updateItemComment(itemKey, _commentController.text.toString());
      setState(() {
        _refreshItems();
        _commentController.text = '';
      });
    }
  }

  void _deleteComment(int itemKey, String indexComment, setState) {
    todoBox.deleteComment(itemKey, indexComment);
    setState(() {
      _refreshItems();
    });
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
        List arr = file.path.toString().split('.');
        setState(() {
          if (['jpg', 'png'].contains(arr.last)) {
            imagesPath.add(file.path.toString());
          }
        });
      }
    }
  }

  // TextFields' controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  void _showForm(BuildContext context, int? itemKey) async {
    print(MediaQuery.of(context).size.width);
    dynamic currentItemComment = [];
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      currentItemComment = existingItem['comments'] ?? [];
      _titleController.text = existingItem['title'];
      _descController.text = existingItem['desc'];
      setState(() {
        imagesUploaded = existingItem['assets'] ?? [];
      });
    } else {
      _titleController.text = '';
      _descController.text = '';
      setState(() {
        imagesPath = [];
        imagesUploaded = [];
      });
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        backgroundColor: Colors.yellow.shade50,
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
                        left: 0,
                        right: 0),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // const SizedBox(height: 24),
                          TextField(
                            controller: _titleController,
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
                            controller: _descController,
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
                                          borderRadius: const BorderRadius.all(
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
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for (var comment in currentItemComment)
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // border: BoxBorder(),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.lime.shade400,
                                                    blurRadius: 2,
                                                    spreadRadius: 0)
                                              ],
                                            ),
                                            // width: MediaQuery.of(context).size.width,
                                            margin: const EdgeInsets.only(
                                                top: 12, bottom: 12, right: 0),
                                            padding: const EdgeInsets.only(
                                                top: 12,
                                                bottom: 12,
                                                left: 24,
                                                right: 24),
                                            child: Text(
                                              comment,
                                              softWrap: true,
                                              // overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          child: IconButton(
                                            iconSize: 16,
                                            onPressed: () {
                                              if (itemKey != null) {
                                                _deleteComment(
                                                    itemKey, comment, setModalState);
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.remove_circle),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
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
                        colors: <Color>[Colors.orange, Colors.yellow.shade100],
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
                                    'title': _titleController.text,
                                    'desc': _descController.text,
                                    'assets': [...imagesUploaded, ...imagesPath]
                                  });
                                }

                                // update an existing item
                                if (itemKey != null) {
                                  _updateItem(itemKey, {
                                    'title': _titleController.text.trim(),
                                    'desc': _descController.text.trim(),
                                    'assets': [...imagesUploaded, ...imagesPath]
                                  });
                                }

                                // Clear the text fields
                                _titleController.text = '';
                                _descController.text = '';

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
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade50,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.lime.shade400,
                                blurRadius: 3,
                                spreadRadius: 0)
                          ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            flex: 5,
                            child: itemKey != null
                                ? Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade50,
                                    ),
                                    child: TextField(
                                      controller: _commentController,
                                      minLines: 4,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText: 'Write something...',
                                          border: InputBorder.none,
                                          filled: true,
                                          fillColor: Colors.yellow.shade50,
                                          // labelText: ('Comment'),
                                          labelStyle:
                                              const TextStyle(fontSize: 12)),
                                    ),
                                  )
                                : Container(),
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.only(top: 10, left: 5),
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade50,
                              ),
                              child: Wrap(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  itemKey != null
                                      ? Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // _pickerFile(setModalState);
                                              _saveComment(
                                                  itemKey, setModalState);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.send_outlined,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 8,
                                    height: 8,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _pickerFile(setModalState);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.green.shade400),
                                      shadowColor:
                                          const MaterialStatePropertyAll(
                                              Colors.transparent),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.attach_file,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
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
