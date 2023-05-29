// 最初に表示される画面
import 'package:flutter/material.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('SPICY-RANKING'),
      backgroundColor: Colors.red[400],
      // elevatino: widgetが浮いてるような影をつける
      elevation: 10,
    );
  }
}