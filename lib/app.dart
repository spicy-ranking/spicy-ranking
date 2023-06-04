// 最初に表示される画面
import 'package:flutter/material.dart';
import 'package:spicy_ranking/view/input_page.dart';
import 'package:spicy_ranking/view/ranking_page.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  // タブバーとそれに連動するタブページを表示する
  @override
  TabBarPageState createState() => TabBarPageState();

  // ページを表示するだけの
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: buildAppBar(),
  //     body: const Input(),
  //   );
  // }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     title: const Text('SPICY-RANKING'),
  //     backgroundColor: Colors.red[400],
  //     // elevatino: widgetが浮いてるような影をつける
  //     elevation: 10,
  //   );
  // }
}

class TabBarPageState extends State<AppScreen> {
  // タブバーで表示するアイコンのリストを_tabに格納
  final tab = <Tab>[
    const Tab(text: "Ranking"),
    const Tab(text: "Input"),
  ];

  // TabBar,TabBarView, DefaultTabControllerを使い、タブバーとそれに連動するタブページを表示
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SPICY-RANKING'),
          backgroundColor: Colors.red[400],
          // elevatino: widgetが浮いてるような影をつける
          elevation: 10,
          bottom: TabBar(tabs: tab),
        ),
        body: const TabBarView(
          children: <Widget>[RankPage(), Input()],
        ),
      ),
    );
  }
}

// TabPageの詳細を設定するクラス
class TabPage extends StatelessWidget {
  final String title;

  // コンストラクタの作成(titleとiconを引数にして親クラスを継承)
  const TabPage({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Textに適応させるTextStyleをTheme(headlineSmall)から持ってくる <- headline5から変更
    final TextStyle? textStyle = Theme.of(context).textTheme.headlineSmall;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: textStyle),
        ],
      ),
    );
  }
}