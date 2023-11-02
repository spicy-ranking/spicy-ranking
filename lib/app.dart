// 最初に表示される画面
import 'package:flutter/material.dart';
import 'package:spicy_ranking/routing/start_route.dart';
//import 'package:spicy_ranking/view/input_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spicy_ranking/view/ranking_page.dart';
//import 'package:spicy_ranking/view/history_page.dart';
import 'package:spicy_ranking/view/start_page.dart';
// import 'package:spicy_ranking/view/account_page.dart';
import 'package:spicy_ranking/routing/login_judge.dart';
import 'dart:async';

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
  final tab = <Tab>[
    const Tab(text: "Ranking"),
    const Tab(text: "Input"),
    const Tab(text: "History")
  ];

  bool isUserLoggedIn = false;
  StreamSubscription<User?>? authStateSubscription;

  @override
  void initState() {
    super.initState();
    // FirebaseAuthのauthStateChanges() ストリームを監視
    authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // ログイン状態を更新
      final newUserLoggedIn = user != null;

      if (newUserLoggedIn != isUserLoggedIn) {
        if (mounted) { // ウィジェットがまだマウントされているかどうかを確認
          setState(() {
            isUserLoggedIn = newUserLoggedIn;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // サブスクリプションをキャンセル
    authStateSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SPICY-RANKING'),
          actions: <Widget>[
            if (isUserLoggedIn)
              IconButton(
                icon: const Icon(Icons.logout), 
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
          ],
          backgroundColor: Colors.red[400],
          automaticallyImplyLeading: false,
          // elevation: widgetが浮いてるような影をつける
          elevation: 10,
          bottom: TabBar(tabs: tab),
        ),
        body: TabBarView(
          children: <Widget>[const RankPage(), LoginJudgeInput(), LoginJudgeHistory()],
        ),
      ),
    );
  }
}
