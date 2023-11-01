// 最初に表示される画面
import 'package:flutter/material.dart';
import 'package:spicy_ranking/routing/start_route.dart';
import 'package:spicy_ranking/view/input_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spicy_ranking/view/ranking_page.dart';
import 'package:spicy_ranking/view/history_page.dart';
import 'package:spicy_ranking/view/start_page.dart';
// import 'package:spicy_ranking/view/account_page.dart';
import 'package:spicy_ranking/routing/login_judge.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  // start_pageを表示
  @override
  StartPageState createState() => StartPageState();

  // タブバーとそれに連動するタブページを表示する
  // @override
  // TabBarPageState createState() => TabBarPageState();

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

class StartPageState extends State<AppScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Start(),
    );
  }

}

class TabBarPageState extends State<StartRoute> {
  // タブバーで表示するアイコンのリストを_tabに格納
  final tab = <Tab>[
    const Tab(text: "Ranking"),
    const Tab(text: "Input"),
    const Tab(text: "History")
  ];

  // TabBar,TabBarView, DefaultTabControllerを使い、タブバーとそれに連動するタブページを表示
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return DefaultTabController(
      length: tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SPICY-RANKING'),
          actions: <Widget>[
            IconButton(
              onPressed: () async{
                await _auth.signOut();
              if (_auth.currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ログアウトしました'),
                  ),
                );
                print('ログアウトしました！');
              }},
              icon: Icon(Icons.account_circle),
            )],
          backgroundColor: Colors.red[400],
          // elevation: widgetが浮いてるような影をつける
          elevation: 10,
          bottom: TabBar(tabs: tab),
        ),
        body:  TabBarView(
          children: <Widget>[const RankPage(), LoginJudge_input(), LoginJudge_history()],
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
