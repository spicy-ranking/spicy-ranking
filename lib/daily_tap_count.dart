import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

Future<int> getDailyClickCount() async {
  final user = _auth.currentUser;
  if (user != null) {
    final today = DateTime.now();
    final userDoc = _firestore.collection('users').doc(user.uid);
    final clickData = await userDoc.collection('clicks').where('date', isEqualTo: today).where('userId', isEqualTo: user.uid).get();
    return clickData.docs.length;
  }
  return 0;
}

Future<int> ClickSet() async {
  final user = _auth.currentUser;
  if (user != null) {
    final today = DateTime.now();
    await _firestore.collection("clicks").doc().set({"data" : today, "userId": user.uid});
  }
  return 0;
}

Future<bool> tapJudge() async {
  final dailyClickCount = await getDailyClickCount();
  if (dailyClickCount < 3) {
    // ボタンクリックを許可
    return true;
    // ボタンのアクションを実行
  } else {
    return false;
    // ボタンクリック制限に達したため、クリックは許可されません
  }
}
