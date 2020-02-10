import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'component/welcome.dart';
import 'provider/pana.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AssetFlare assetFlare;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Padding(
              child: FlareActor.asset(assetFlare, animation: 'coding'),
              padding: EdgeInsets.only(top: 100),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: WelcomeItem(),
              padding: EdgeInsets.only(top: 80),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    assetFlare =
        PreloadAssetFlare(bundle: rootBundle, name: 'assets/coding.flr');
    Provider.of<DataProvider>(context, listen: false).loadData();
  }

  Future task() {
    return assetFlare.load().then((_) => _);
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

  PreloadAssetFlare({@required AssetBundle bundle, @required String name})
      : super(bundle: bundle, name: name);

  @override
  Future<ByteData> load() async {
    if (data == null) {
      data = await super.load();
    }
    return data;
  }
}
