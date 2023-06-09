import 'package:flutter/material.dart';
import 'package:spicy_ranking/app.dart';
import 'package:spicy_ranking/constant/constants.dart';
import 'package:spicy_ranking/components/drop_box_hot_menu.dart';
import '../components/drop_box_product_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  callback(String? product) {
    // コールバック関数の引数を追加
    setState(() {
      if (product == firstProductName) {
        firstProductName = product;
      } else if (product == secondProductName) {
        secondProductName = product;
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
          const DropBoxHotMenu(),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Press");
                  debugPrint(firstProductName);
                  debugPrint(secondProductName);
                  if (firstProductName != null && secondProductName != null) {
                    CollectionReference cupNoodleCollection = FirebaseFirestore
                        .instance
                        .collection('spicy-cup-noodle');

                    cupNoodleCollection
                        .where('name',
                            whereIn: [firstProductName, secondProductName])
                        .get()
                        .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            double rate = (querySnapshot.docs[0].data()
                                as Map<String, dynamic>)['rate'];
                            debugPrint('Rate: $rate');
                          } else {
                            debugPrint('No matching documents.');
                          }
                        });
                  } else {
                    () {
                      debugPrint("these are null");
                    };
                  }
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
