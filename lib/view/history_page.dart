import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spicy_ranking/routing/calcurate.dart';
import 'package:spicy_ranking/routing/send_route.dart';
import 'package:spicy_ranking/account/daily_tap_count.dart';
import 'dart:math';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:timeago/timeago.dart' as timeAgo; //時間差分計算用パッケージ


class History { //履歴クラス

  late String id; // ドキュメントID
  late String hot; //辛いもの
  late String cold; //辛くないもの
  late int good; //賛成数
  late int bad; //反対数
  late int time; //入力された時間

  History(
      {required this.id,
      required this.hot,
      required this.cold,
      required this.good,
      required this.bad,
      required this.time});

  factory History.fromMap(String id, Map<String, dynamic> data) {
    return History(
        id: id,
        hot: data['hot'],
        cold: data['cold'],
        good: data['good'],
        bad: data['bad'],
        time: data['time']);
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Streamを使用して、モデルクラスから、データを取得するメソッド
  Stream<List<History>> _fetchHistorysStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore
        .collection('history')
        .orderBy('time', descending: true)
        .snapshots(); //時系列順に取得
    return stream.map((snapshot) => snapshot.docs.map((doc) {
          final historyId = doc.id;
          return History.fromMap(historyId, doc.data());
        }).toList());
  }

//イロレーティング評価関数
  List valueFunction(int firstRate, int secondRate, bool firstWin) {
    if (firstWin) {
      int deltaRate = 32 ~/ ((pow(10, (firstRate - secondRate) / 400)) + 1);
      firstRate = firstRate + deltaRate;
      secondRate = secondRate - deltaRate;
    } else {
      int deltaRate = 32 ~/ ((pow(10, (secondRate - firstRate) / 400)) + 1);
      firstRate = firstRate - deltaRate;
      secondRate = secondRate + deltaRate;
    }
    return [firstRate, secondRate];
  }

//時間の差分計算
  String createTimeAgoString(int timestamp) {
    timeAgo.setLocaleMessages("ja", timeAgo.JaMessages());
    final now = DateTime.now();
    DateTime postDateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final difference = now.difference(postDateTime);
    return timeAgo.format(now.subtract(difference), locale: "ja");
  }

  @override
  Widget build(BuildContext context) {
    // ListとHistoryクラスを指定する
    return StreamBuilder<List<History>>(
      // 上で定義したメソッドを使用する
      stream: _fetchHistorysStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final historys = snapshot.data!;

        return ListView.builder(
          // Listのデータの数を数える
          itemExtent: 140,
          itemCount: historys.length >= 15 ? 15 : historys.length, //最大15個履歴表示

          itemBuilder: (context, index) {
            // index番目から数えて、０〜末尾まで登録されているデータを表示する変数
            final history = historys[index];

            return Column(
              children: [
                ListTile(
              // Historyクラスのメンバ変数を使用する
              title: Text('🥵: ${history.hot}'),
              subtitle: Text('🙂: ${history.cold}'),
              leading: const Icon(Icons.account_circle),
              trailing: Text(createTimeAgoString(history.time)),
              //contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8), // ボタンとの余白を設定
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                children: [                 
                  //いいねボタン
                  OutlinedButton.icon(
                    onPressed: () async{
                      bool canTap = await tapJudge();
                      if(canTap){
                      CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
                      CollectionReference cupNoodleCollection = FirebaseFirestore.instance.collection('spicy-cup-noodle');
                      int firstRate = 0;
                      int secondRate = 0;
                      int firstRd = 0;
                      double firstVol = 0; // firebase 登録の値が小数だからdouble型
                      int secondRd = 0;
                      double secondVol = 0; // firebase 登録の値が小数だからdouble型
                      // クリックされた履歴のIDを取得
                      await historyCollection.doc(history.id).update({
                        'good': history.good + 1, //いいねカウントアップ
                      });
                      //辛いもの辛くないものの２つのレート取得
                      await cupNoodleCollection.where( 'name',
                        whereIn:[history.hot]
                      ).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            firstRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            firstRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            firstVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            debugPrint('First Rate: $firstRate');
                          }
                      });
                      await cupNoodleCollection.where( 'name',
                        whereIn:[history.cold]
                      ).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            secondRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            secondVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            debugPrint('second Rate: $secondRate');
                          }
                      });  
                      //グリコレーティング計算
                      final winner = setPlayer(firstRate.toDouble(), firstRd.toDouble(), firstVol.toDouble());
                      final loser = setPlayer(secondRate.toDouble(), secondRd.toDouble(), secondVol.toDouble());

                      final players = <Player>[winner, loser];

                      // win: 1, lose: 2
                      final ranks = [1, 2];

                      final newPlayers = calcRatings(players, ranks);


                      debugPrint(newPlayers[0].rating.toString());
                      debugPrint(newPlayers[1].rating.toString());

                      // 変数を更新
                      firstRate = newPlayers[0].rating.toInt();
                      firstRd = newPlayers[0].rd.toInt();
                      firstVol = newPlayers[0].vol;
                      secondRate = newPlayers[1].rating.toInt();
                      secondRd = newPlayers[1].rd.toInt();
                      secondVol = newPlayers[1].vol;

                      //List result = valueFunction(firstRate, secondRate, true); イロレーティング用

                      debugPrint('New First Rate: ${firstRate}');
                      debugPrint('New Second Rate: ${secondRate}');
                     //レート代入
                      await cupNoodleCollection.where('name',
                              whereIn: [history.hot])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': firstRate, 'rd': firstRd, 'vol': firstVol}).then((_) {
                              debugPrint('First Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update First Rate: $error');
                            });
                          });
                      await cupNoodleCollection.where('name',
                              whereIn: [history.cold])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': secondRate,'rd': secondRd, 'vol': secondVol}).then((_) {
                              debugPrint('Second Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update Second Rate: $error');
                            });
                          });
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('今日の投票数制限(3回)を超えました'),
                    ));}
                    },
                    icon: const Icon(Icons.thumb_up),
                    label:Text('${history.good}'),
                    style:OutlinedButton.styleFrom(
                      foregroundColor:Colors.red,
                      //minimumSize: Size.zero,
                      padding: EdgeInsets.zero,

                    ),
                  ),
                  const SizedBox(width: 20), //横幅調整
                 //よくないねボタン
                  OutlinedButton.icon(
                    onPressed: () async{
                      bool canTap = await tapJudge();
                      if(canTap){
                      CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
                      CollectionReference cupNoodleCollection = FirebaseFirestore.instance.collection('spicy-cup-noodle');
                      int firstRate = 0;
                      int secondRate = 0;
                      int firstRd = 0;
                      double firstVol = 0; // firebase 登録の値が少数だからdouble型
                      int secondRd = 0;
                      double secondVol = 0; // firebase 登録の値が少数だからdouble型

                      // クリックされた履歴のIDを取得
                      await historyCollection.doc(history.id).update({
                        'bad': history.bad + 1, //よくないねカウントアップ
                    });
                                           //辛いもの辛くないものの２つのレート取得
                      await cupNoodleCollection.where( 'name',
                        whereIn:[history.hot]
                      ).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            firstRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            firstRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            firstVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            debugPrint('First Rate: $firstRate');
                          }
                      });
                      await cupNoodleCollection.where( 'name',
                        whereIn:[history.cold]
                      ).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            secondRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            secondVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            debugPrint('second Rate: $secondRate');
                          }
                      });  
                      //レート計算

                      final winner = setPlayer(secondRate.toDouble(), secondRd.toDouble(), secondVol.toDouble());
                      final loser = setPlayer(firstRate.toDouble(), firstRd.toDouble(), firstVol.toDouble());

                      final players = <Player>[winner, loser];

                      // win: 1, lose: 2
                      final ranks = [1, 2];

                      final newPlayers = calcRatings(players, ranks);

                      debugPrint(newPlayers[0].rating.toString());
                      debugPrint(newPlayers[1].rating.toString());

                      // 変数を更新
                      secondRate = newPlayers[0].rating.toInt();
                      secondRd = newPlayers[0].rd.toInt();
                      secondVol = newPlayers[0].vol;
                      firstRate = newPlayers[1].rating.toInt();
                      firstRd = newPlayers[1].rd.toInt();
                      firstVol = newPlayers[1].vol;

                     //List result = valueFunction(firstRate, secondRate, false); //ここだけ変更
                      debugPrint('New First Rate: ${firstRate}');
                      debugPrint('New Second Rate: ${secondRate}');

                      //レート代入
                      await cupNoodleCollection.where('name',
                              whereIn: [history.hot])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': firstRate, 'rd': firstRd, 'vol': firstVol}).then((_) {
                              debugPrint('First Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update First Rate: $error');
                            });
                          });
                      await cupNoodleCollection.where('name',
                              whereIn: [history.cold])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': secondRate,'rd': secondRd, 'vol': secondVol}).then((_) {
                              debugPrint('Second Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update Second Rate: $error');
                            });
                          });}
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('今日の投票数制限(3回)を超えました'),
                        ));}
                    },
                    icon: const Icon(Icons.thumb_down),
                    label:Text('${history.bad}'),
                    style:OutlinedButton.styleFrom(
                      primary: Colors.blue,
                      //minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                height: 1,
                thickness: 2,
                color: Colors.grey,
              ),
              //SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }
}
