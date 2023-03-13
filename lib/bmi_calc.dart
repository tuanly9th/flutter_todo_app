import 'package:flutter/material.dart';
import 'navigation/menu_bottom.dart';
import 'navigation/menu_draw.dart';

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      drawer: const MenuDrawer(),
      bottomNavigationBar: const MenuBottom(),
      body: const Center(child: FlutterLogo(
        size: 250,
      )),
    );
  }
}
