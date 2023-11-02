import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spicy_ranking/view/input_page.dart';
import 'package:spicy_ranking/view/history_page.dart';
import 'package:spicy_ranking/view/login_restrict_page.dart';
class LoginJudgeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return const Input();
            }
            // User が null である、つまり未サインインのサインイン画面へ
          return UserLogin_restrict(); 
          },
        ),
      );
}

class LoginJudgeHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // User が null でなない、つまりサインイン済みのホーム画面へ
              return const HistoryPage();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return UserLogin_restrict();
          },
        ),
      );
}