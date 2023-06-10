import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            // 水平方向にpaddingが入っている
            padding: EdgeInsets.symmetric(vertical: 100),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "SPICY-RANKINGへ\nようこそ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 36
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 250,
              height: 120,
              child: ElevatedButton(
                onPressed: () {/* ボタンが押された時の処理 */},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'はじめる',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36
                    ),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
