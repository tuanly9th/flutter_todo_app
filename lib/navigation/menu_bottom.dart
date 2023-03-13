import 'package:flutter/material.dart';

class MenuBottom extends StatefulWidget {
  const MenuBottom({super.key});
  // final int index;
  @override
  State<MenuBottom> createState() => _MenuBottomState();
}

class _MenuBottomState extends State<MenuBottom> {
  void _changeTab(int value) {
    switch (value) {
      case 0:
        if ('/' != ModalRoute.of(context)?.settings.name) {
          Navigator.pushNamed(context, '/');
        }
        break;
      case 1:
        if ('/calculator' != ModalRoute.of(context)?.settings.name) {
          Navigator.pushNamed(context, '/calculator');
        }
        break;
      case 2:
        if ('/todo' != ModalRoute.of(context)?.settings.name) {
          Navigator.pushNamed(context, '/todo');
        }
        break;
    }
  }

  int getIndex() {
    if (ModalRoute.of(context)?.settings.name == '/calculator') {
      return 1;
    } else
    if (ModalRoute.of(context)?.settings.name == '/todo') {
      return 2;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
  print(ModalRoute.of(context)?.settings.name);

    return BottomNavigationBar(
      currentIndex: getIndex(),
      selectedItemColor: Colors.green.shade400,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate_outlined),
          label: 'BMI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.today_rounded),
          label: 'TODO',
        ),
      ],
      onTap: _changeTab,
    );
  }
}
