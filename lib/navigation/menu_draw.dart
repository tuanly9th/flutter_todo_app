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
          switch (element) {
            case 'Home':
              screen = const MyHomePage(title: 'Home');
              break;
            case 'BMI':
              screen = const BMICalculator();
              break;
            case 'TODO':
              screen = const TodoPage();
              break;
            // default:
            //   screen = Container(
            //     child: const Center(child: Text('Hello Flutter')),
            //   );
          }
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => screen));
        },
      ));
    });

    return menuItems;
  }
}
