import 'package:flutter/material.dart';
import '../bmi_calc.dart';
import '../home.dart';
import '../todo_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    int idx = 1;
    List<String> menuTitles = ['Home', 'BMI', 'TODO'];
    List<Widget> menuItems = [];
    menuItems.add(DrawerHeader(
        child: Text(
      'Menu',
      style: TextStyle(
        color: Colors.red.shade400,
        fontSize: 24,
      ),
    )));

    menuTitles.forEach((element) {
      Widget screen = Container();
      idx++;
      menuItems.add(ListTile(
        title: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green[100 * idx],
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Text(
              element,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          switch (element) {
            case 'Home':
              screen = const MyHomePage(title: 'Home');
              if ('/' != ModalRoute.of(context)?.settings.name) {
                Navigator.pushNamed(context, '/');
              }
              break;
            case 'BMI':
              screen = const BMICalculator();
              if ('/calculator' != ModalRoute.of(context)?.settings.name) {
                Navigator.pushNamed(context, '/calculator');
              }
              break;
            case 'TODO':
              screen = const TodoPage();
              if ('/todo' != ModalRoute.of(context)?.settings.name) {
                Navigator.pushNamed(context, '/todo');
              }
              break;
          }
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => screen));
        },
      ));
    });

    return menuItems;
  }
}
