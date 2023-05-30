import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: AppScreen(),
      //右上に出る"Debag"マークをけす
      debugShowCheckedModeBanner: false,

      // stream_page表示
      // home: Scaffold(
      //   appBar: AppBar(title: const Text('カップ麺一覧')),
      //   body: const StreamPage(),
      // ),

      // title: 'Flutter Demo',
      // theme: ThemeData(
      //    textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
      //    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //    useMaterial3: true,
      // ),
      
    );
  }
}