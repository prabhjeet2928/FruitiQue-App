import 'package:flutter/material.dart';
import 'package:fruitique_app/database/auth.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Image.asset(
          "assets/fruit_back.jpg",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Container(
          height: 470,
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(10),
            elevation: 10,
            child: MaterialButton(
              minWidth: 250,
              height: 60,
              textColor: Colors.white,
              child: Text("Get Started", style: TextStyle(fontSize: 20.0)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
            ),
          ),
        ),
      ],
    ));
  }
}
