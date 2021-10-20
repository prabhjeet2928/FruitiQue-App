import 'package:flutter/material.dart';
import 'package:fruitique_app/screens/home.dart';
import 'package:fruitique_app/screens/fruitiquee.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset("assets/fuitique.jpeg"),
      title: Text(
        "FruitiQue",
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      navigator: AfterSplash(),
      durationInSeconds: 8,
      logoSize: 100,
      loaderColor: Colors.green,
      loadingText: Text(
        "     from\nEpic Dream",
        style: TextStyle(
            fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
      ),
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHome();
  }
}
