import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:timeago/timeago.dart' as timeAgo; //時間差分計算用パッケージ

class History { //履歴クラス
  late String id; // ドキュメントID
  late String hot; //辛いもの
  late String cold; //辛くないもの
  late int good; //賛成数
  late int bad; //反対数
  late int time; //入力された時間

  History({required this.id, required this.hot, required this.cold, required this.good, required this.bad, required this.time});

  factory History.fromMap(String id, Map<String, dynamic> data) {
    return History(id: id, hot: data['hot'], cold: data['cold'], good: data['good'], bad: data['bad'], time: data['time']);
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // Streamを使用して、モデルクラスから、データを取得するメソッド
  Stream<List<History>> _fetchHistorysStream() {
    final firestore = FirebaseFirestore.instance;
    final stream = firestore.collection('history').orderBy('time', descending:true).snapshots(); //時系列順に取得
    return stream.map((snapshot) => snapshot.docs.map((doc) {
          final historyId = doc.id;
          return History.fromMap(historyId, doc.data());
        }).toList());
  }

//評価関数
List valueFunction(int firstRate, int secondRate, bool firstWin){
  if (firstWin){
  int deltaRate = 32 ~/ ((pow(10, (firstRate - secondRate) / 400)) + 1);
  firstRate = firstRate + deltaRate;
  secondRate = secondRate - deltaRate;
  }
  else{
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
  DateTime postDateTime =  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
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
          itemCount: historys.length >= 15 ? 15: historys.length, //最大15個履歴表示

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
                    onPressed:() async{
                      CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
                      CollectionReference cupNoodleCollection = FirebaseFirestore.instance.collection('spicy-cup-noodle');
                      int firstRate = 0;
                      int secondRate = 0;
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
                            debugPrint('First Rate: $firstRate');
                          }
                      });
                      await cupNoodleCollection.where( 'name',
                        whereIn:[history.cold]
                      ).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            debugPrint('second Rate: $secondRate');
                          }
                      });  
                      //レート計算
                      List result = valueFunction(firstRate, secondRate, true);
                      debugPrint('New First Rate: ${result[0]}');
                      debugPrint('New Second Rate: ${result[1]}');
                     //レート代入
                      await cupNoodleCollection.where('name',
                              whereIn: [history.hot])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': result[0]}).then((_) {
                              debugPrint('First Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update First Rate: $error');
                            });
                          });
                      await cupNoodleCollection.where('name',
                              whereIn: [history.cold])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': result[1]}).then((_) {
                              debugPrint('Second Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update Second Rate: $error');
                            });
                          });
                    },
                    icon: const Icon(Icons.thumb_up),
                    label:Text('${history.good}'),
                    style:OutlinedButton.styleFrom(
                      primary:Colors.red,
                      //minimumSize: Size.zero,
                      padding: EdgeInsets.zero,

                    )
                  ),
                  SizedBox(width: 20), //横幅調整
                 //よくないねボタン
                  OutlinedButton.icon(
                    onPressed:() async{
                      CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
                      CollectionReference cupNoodleCollection = FirebaseFirestore.instance.collection('spicy-cup-noodle');
                      int firstRate = 0;
                      int secondRate = 0;
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
                            debugPrint('First Rate: $firstRate');
                          }
                      });
                      await cupNoodleCollection.where( 'name',
                        whereIn:[history.cold]
                      ).get().then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            debugPrint('second Rate: $secondRate');
                          }
                      });  
                      //レート計算
                      List result = valueFunction(firstRate, secondRate, false); //ここだけ変更
                      debugPrint('New First Rate: ${result[0]}');
                      debugPrint('New Second Rate: ${result[1]}');

                      //レート代入
                      await cupNoodleCollection.where('name',
                              whereIn: [history.hot])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': result[0]}).then((_) {
                              debugPrint('First Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update First Rate: $error');
                            });
                          });
                      await cupNoodleCollection.where('name',
                              whereIn: [history.cold])
                          .get().then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.first.reference
                                .update({'rate': result[1]}).then((_) {
                              debugPrint('Second Rate updated successfully');
                            }).catchError((error) {
                              debugPrint('Failed to update Second Rate: $error');
                            });
                          });
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
              SizedBox(height: 10),
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