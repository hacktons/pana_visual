import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'component/widget/file_picker.dart';
import 'provider/pana.dart';

class SplashPage extends StatefulWidget {
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
        child: Stack(
          children: <Widget>[
            Padding(
              child: FlareActor.asset(assetFlare, animation: 'coding'),
              padding: EdgeInsets.only(top: 100),
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Text('Pana Visual',
                      style: Theme.of(context).textTheme.display3),
                  Padding(padding: EdgeInsets.only(bottom: 8)),
                  Text(
                      'Preview the health and quality of a Dart/Flutter package before publish.',
                      style: Theme.of(context).textTheme.subtitle),
                  Padding(padding: EdgeInsets.only(bottom: 8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                        child: Text('Sample',
                            style: Theme.of(context).textTheme.headline),
                        onPressed: () {
                          jump2Home();
                        },
                      ),
                      Padding(padding: EdgeInsets.only(right: 8)),
                      OutlineButton(
                        child: Text('Upload',
                            style: Theme.of(context).textTheme.headline),
                        onPressed: () {
                          FilePicker.pickFile().then((file) {
                            return file.text;
                          }).then((json) {
                            var data = jsonDecode(json);
                            Provider.of<DataProvider>(context, listen: false)
                                .setData(data);
                            jump2Home();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
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

  void jump2Home() {
    Navigator.of(context).pushReplacementNamed('/home', arguments: true);
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
