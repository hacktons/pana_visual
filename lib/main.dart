import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'provider/pana.dart';
import 'splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pana Visual',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => SplashPage(),
          '/home': (_) => HomePage(),
        },
      ),
    );
    ;
  }
}

