import 'package:flutter/material.dart';
import 'package:flutter_app/Home.dart';
import 'package:splashscreen/splashscreen.dart';


class Spalsh extends StatefulWidget {
  const Spalsh({Key key}) : super(key: key);

  @override
  _SpalshState createState() => _SpalshState();
}

class _SpalshState extends State<Spalsh> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: Home(),
      imageBackground: Image.asset('assets/back.jpg').image,
      loaderColor: Colors.white,
      useLoader: true,
      loadingText: Text('در حال بارگزاری...',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
    );
  }
}
