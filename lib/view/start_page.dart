import 'package:flutter/material.dart';
import 'package:spicy_ranking/routing/start_route.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            // 水平方向にpaddingが入っている
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset('images/spicy-ranking_logo.png'),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 250,
              height: 120,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StartRoute()),
                  );
                },
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
