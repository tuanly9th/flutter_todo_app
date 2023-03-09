import 'package:flutter/material.dart';
import '../bmi_calc.dart';
import '../home.dart';

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
    List<String> menuTitles = ['Home', 'BMI'];
    List<Widget> menuItems = [];
    menuItems.add(DrawerHeader(
        child: Text(
      'Golbo Fit',
      style: TextStyle(
        color: Colors.red.shade400,
        fontSize: 24,
      ),
    )));

    menuTitles.forEach((element) {
      Widget screen = Container();
      menuItems.add(ListTile(
        title: Text(
          element,
          style: const TextStyle(fontSize: 18),
        ),
        onTap: () {
          switch (element) {
            case 'Home':
              screen = const MyHomePage(title: 'Home');
              break;
            case 'BMI':
              screen = const BMICalculator();
              break;
            // default:
            //   screen = Container(
            //     child: const Center(child: Text('Hello Flutter')),
            //   );
          }
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
        },
      ));
    });

    return menuItems;
  }
}
