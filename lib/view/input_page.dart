import 'package:flutter/material.dart';
import 'package:spicy_ranking/app.dart';
import 'package:spicy_ranking/constant/constants.dart';
import 'package:spicy_ranking/components/drop_box_hot_menu.dart';
import '../components/drop_box_product_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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
  int firstRate = 0;
  int secondRate = 0;
  callback(String? product) {
    // コールバック関数の引数を追加
    setState(() {
      if (product == firstProductName) {
        firstProductName = product;
      } else if (product == secondProductName) {
        secondProductName = product;
      } else if (product == hotCold) {
        hotCold = product;
      }
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

  void updateDropBoxHotMenuValue(String? value) {
    setState(() {
      hotCold = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "Input",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          DropdownButtonProductMenu1(
            onProductChanged: updateFirstProductName,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "は",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          DropdownButtonProductMenu2(
            onProductChanged: updateSecondProductName,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "よりも",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          DropBoxHotMenu(
            onHotColdChanged: updateDropBoxHotMenuValue,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // 非同期処理を行うためにasyncを追加
                  debugPrint(firstProductName);
                  debugPrint(secondProductName);
                  debugPrint(hotCold);
                  if (firstProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where(FieldPath.documentId,
                            whereIn: [firstProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            firstRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
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
                        .where(FieldPath.documentId,
                            whereIn: [secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            secondRate = (querySnapshot.docs.first.data()
                                as Map<String, dynamic>)['rate'];
                            debugPrint('Second Rate: $secondRate');
                          } else {
                            debugPrint('No documents2.');
                          }
                        });
                  } else {
                    debugPrint("these are null");
                  }

                  if (hotCold == "辛い") {
                    int deltaRate =
                        32 ~/ ((pow(10, (firstRate - secondRate) / 400)) + 1);
                    firstRate = firstRate + deltaRate;
                    secondRate = secondRate - deltaRate;
                  } else if (hotCold == "辛くない") {
                    int deltaRate =
                        32 ~/ ((pow(10, (secondRate - firstRate) / 400)) + 1);
                    firstRate = firstRate - deltaRate;
                    secondRate = secondRate + deltaRate;
                  }

                  debugPrint('New First Rate: $firstRate');
                  debugPrint('New Second Rate: $secondRate');

                  if (firstProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    await cupNoodleCollection
                        .where(FieldPath.documentId,
                            whereIn: [firstProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.first.reference
                              .update({'rate': firstRate}).then((_) {
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
                        .where(FieldPath.documentId,
                            whereIn: [secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.first.reference
                              .update({'rate': secondRate}).then((_) {
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
                          builder: (context) => const AppScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('送信'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
