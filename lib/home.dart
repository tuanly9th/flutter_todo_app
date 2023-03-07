import 'package:flutter/material.dart';
import 'package:flutter_first_app/data/database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'components/todo_tile.dart';
import 'components/todo_tile_ver2.dart';
import 'components/dialog_box.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // reference hive box
  final _todoBox = Hive.box('todoBox');

  TodoDataBase db = TodoDataBase();

  @override
  void initState() {
    if (_todoBox.get('TodoList') == null) {
      db.createInitial();
    } else {
      db.loadData();
    }
    super.initState();
  }
  // 
  // List todoList = [
  //   ['Make Todo task', true],
  //   ['Make Todo task', false],
  // ];

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
    });
    _controller.text = '';
    db.updateData();
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTaskFunc(int index) {
    // log(index);
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('TODO'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(top: 36),
          itemCount: db.todoList.length,
          itemBuilder: (context, index) {
            
            return index % 2 == 0 ? ToDoTileV2(
              taskName: db.todoList[index][0],
              taskCompleted: db.todoList[index][1],
              onChanged: (val) => checkBoxChanged(val, index),
              deleteTask: () => deleteTaskFunc(index),
            ) : ToDoTile(
              taskName: db.todoList[index][0],
              taskCompleted: db.todoList[index][1],
              onChanged: (val) => checkBoxChanged(val, index),
              deleteTask: (context) => deleteTaskFunc(index),
            );
          }),
    );
  }
}
