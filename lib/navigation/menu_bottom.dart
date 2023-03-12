import 'package:flutter/material.dart';

class MenuBottom extends StatelessWidget {
  const MenuBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: const [
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
    onTap: (value) {
      print(value);
      switch (value) {
        case 0:
          Navigator.pushNamed(context, '/');
          break;
        case 1:
          Navigator.pushNamed(context, '/calculator');
          break;
        case 2:
          Navigator.pushNamed(context, '/todo');
          break;
      }
    },);
  }
}
