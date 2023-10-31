import 'package:flutter/material.dart';
// import 'package:spicy_ranking/app.dart';
import 'package:spicy_ranking/constant/constants.dart';
//import 'package:spicy_ranking/components/drop_box_hot_menu.dart';
import 'package:spicy_ranking/routing/calcurate.dart';
import 'package:spicy_ranking/routing/start_route.dart';
import 'package:spicy_ranking/routing/send_route.dart';
import '../components/drop_box_product_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spicy_ranking/routing/login_judge.dart';

// ignore: must_be_immutable
class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  String? firstProductName;
  String? secondProductName;
  String? hotCold;
  String? firstProductNameHis; //履歴用
  String? secondProductNameHis; //履歴用
  int firstRate = 0;
  int firstRd = 0;
  double firstVol = 0; // firebase 登録の値が少数だからdouble型
  int secondRate = 0;
  int secondRd = 0;
  double secondVol = 0; // firebase 登録の値が少数だからdouble型
  DateTime now = DateTime.now();

  callback(String? product) {
    // コールバック関数の引数を追加
    setState(() {
      if (product == firstProductName) {
        firstProductName = product;
      } else if (product == secondProductName) {
        secondProductName = product;
      } //else if (product == hotCold) {
      //   hotCold = product;
     // }
    });
  }

  void updateFirstProductName(String? productName) {
    setState(() {
      firstProductName = productName;
    });
  }

  void updateSecondProductName(String? productName) {
    setState(() {
      secondProductName = productName;
    });
  }

  // void updateDropBoxHotMenuValue(String? value) {
  //   setState(() {
  //     hotCold = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text('商品名1'),
          DropdownButtonProductMenu1(
            onProductChanged: updateFirstProductName,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "は",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          const SizedBox(height: 30),
          const Text('商品名2'),
          DropdownButtonProductMenu2(
            onProductChanged: updateSecondProductName,
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "よりも",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          // DropBoxHotMenu(
          //   onHotColdChanged: updateDropBoxHotMenuValue,
          // ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                ElevatedButton(
                  onPressed: () async{
                  hotCold = '辛い';
                  // 非同期処理を行うためにasyncを追加
                  debugPrint(firstProductName);
                  debugPrint(secondProductName);
                  debugPrint(hotCold);
                  if (firstProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                      .instance
                      .collection('spicy-cup-noodle');
                      await cupNoodleCollection
                        .where('name',
                            whereIn: [firstProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            firstRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            firstRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            firstVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            firstProductNameHis = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['name'];
                            debugPrint('First Rate: $firstRate');
                          } else {
                            debugPrint('No documents1.');
                          }
                        });
                  } else {
                    debugPrint("these are null");
                  }

                  if (secondProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where('name',
                            whereIn: [secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            secondRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            secondVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            secondProductNameHis = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['name'];
                            debugPrint('Second Rate: $secondRate');
                          } else {
                            debugPrint('No documents2.');
                          }
                        });
                  } else {
                    debugPrint("these are null");
                  }
                  
                  if (firstProductName == null || secondProductName == null){
                  
                  }else{
                  // ---ここから評価・送信---
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

                    // 履歴データ追加
                    FirebaseFirestore.instance.collection('history').add({
                    'hot' : firstProductNameHis,
                    'cold' : secondProductNameHis,
                    'good' : 0,
                    'bad' : 0,
                    'time' : now.millisecondsSinceEpoch ~/ 1000,
                    });
                  // ---ここまで評価---
                }

                  // 値が更新されているのか確認
                  debugPrint('New First Rate: $firstRate');
                  debugPrint('New Second Rate: $secondRate');

                  if (firstProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where('name',
                            whereIn: [firstProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.first.reference
                              .update({'rate': firstRate, 'rd': firstRd, 'vol': firstVol}).then((_) {
                            debugPrint('First Rate updated successfully');
                          }).catchError((error) {
                            debugPrint('Failed to update First Rate: $error');
                          });
                        });
                  }

                  if (secondProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where('name',
                            whereIn: [secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.first.reference
                              .update({'rate': secondRate, 'rd': secondRd, 'vol': secondVol}).then((_) {
                            debugPrint('Second Rate updated successfully');
                          }).catchError((error) {
                            debugPrint('Failed to update Second Rate: $error');
                          });
                        });
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartRoute()));
                },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[400],
                  fixedSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: const Text('辛い'),
                ),

                const SizedBox(width: 70),

                ElevatedButton(
                onPressed: () async {
                  hotCold = '辛くない';
                  // 非同期処理を行うためにasyncを追加
                  debugPrint(firstProductName);
                  debugPrint(secondProductName);
                  debugPrint(hotCold);
                  if (firstProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                      .instance
                      .collection('spicy-cup-noodle');
                      await cupNoodleCollection
                        .where('name',
                            whereIn: [firstProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            firstRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            firstRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            firstVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            firstProductNameHis = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['name'];
                            debugPrint('First Rate: $firstRate');
                          } else {
                            debugPrint('No documents1.');
                          }
                        });
                  } else {
                    debugPrint("these are null");
                  }

                  if (secondProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where('name',
                            whereIn: [secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            secondRd = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rd'];
                            secondVol = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['vol'];
                            secondProductNameHis = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['name'];
                            debugPrint('Second Rate: $secondRate');
                          } else {
                            debugPrint('No documents2.');
                          }
                        });
                  } else {
                    debugPrint("these are null");
                  }
                  
                  if (firstProductName == null || secondProductName == null){
                  }else{
                  // ---ここから評価・送信---
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

                    // 履歴データ追加
                    FirebaseFirestore.instance.collection('history').add({
                    'hot' : secondProductNameHis,
                    'cold' : firstProductNameHis,
                    'good' : 0,
                    'bad' : 0,
                    'time' : now.millisecondsSinceEpoch ~/ 1000,
                    });

                  // ---ここまで評価---
                }

                  // 値が更新されているのか確認
                  debugPrint('New First Rate: $firstRate');
                  debugPrint('New Second Rate: $secondRate');

                  if (firstProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where('name',
                            whereIn: [firstProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.first.reference
                              .update({'rate': firstRate, 'rd': firstRd, 'vol': firstVol}).then((_) {
                            debugPrint('First Rate updated successfully');
                          }).catchError((error) {
                            debugPrint('Failed to update First Rate: $error');
                          });
                        });
                  }else{
                    debugPrint("update null");
                  }

                  if (secondProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where('name',
                            whereIn: [secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.first.reference
                              .update({'rate': secondRate, 'rd': secondRd, 'vol': secondVol}).then((_) {
                            debugPrint('Second Rate updated successfully');
                          }).catchError((error) {
                            debugPrint('Failed to update Second Rate: $error');
                          });
                        });
                  }else{
                    debugPrint('update null');
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartRoute()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('辛くない'),
              ),
            ],
            ),
          ],
          ),
      );
  }
}
