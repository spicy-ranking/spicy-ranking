import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:spicy_ranking/view/history_page.dart';
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

Future<int> getDailyClickCount() async {
  final user = _auth.currentUser;
  if (user != null) {
    final today = DateTime.now().day;
    final clickData = await _firestore.collection('clicks').where('date', isEqualTo: today).where('userId', isEqualTo: user.uid).get();
    return clickData.docs.length;
  }
  return 4;
}

Future<int> clickSet() async {
  final user = _auth.currentUser;
  if (user != null) {
    final today = DateTime.now().day;
    await _firestore.collection("clicks").doc().set({"date" : today, "userId": user.uid});
  }
  return 0;
}

Future<bool> tapJudge() async {
  final dailyClickCount = await getDailyClickCount();
  if (dailyClickCount < 3) {
    // ボタンクリックを許可
    debugPrint("${dailyClickCount}");
    await clickSet();
    return true;
    // ボタンのアクションを実行
  } else {
    return false;
    // ボタンクリック制限に達したため、クリックは許可されません
  }
}
