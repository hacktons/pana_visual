import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'provider/pana.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanaDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => SplashPage(title: ''),
          '/home': (_) => HomePage(),
        },
      ),
    );
    ;
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AssetFlare assetFlare;
  Future _task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: _task,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return FlareActor.asset(assetFlare, animation: 'coding');
          }
          return CircularProgressIndicator();
        },
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    assetFlare = AssetFlare(bundle: rootBundle, name: 'assets/coding.flr');
    _task = task();
    Provider.of<PanaDataProvider>(context, listen: false).loadData();
    jump2Home();
  }

  Future task() {
    return assetFlare.load().then((_) => _);
  }

  void jump2Home() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home', arguments: true);
    });
  }

  @override
  void dispose() {
    assetFlare = null;
    super.dispose();
  }
}

// ignore: must_be_immutable
class PreloadAssetFlare extends AssetFlare {
  ByteData data;

  @override
  Future<ByteData> load() async {
    if (data == null) {
      data = await super.load();
    }
    return data;
  }
}
