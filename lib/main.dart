import 'package:flutter/material.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'infra/firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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