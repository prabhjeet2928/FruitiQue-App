import 'package:flutter/material.dart';
import 'package:fruitique_app/database/authentication.dart';
import 'package:fruitique_app/screens/widgets.dart';
import 'package:fruitique_app/database/helperfunctions.dart';
import 'package:fruitique_app/database/database.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruitique_app/screens/fruitiquee.dart';
import 'dart:core';

class MyLogin extends StatefulWidget {
  final Function toggle;
  MyLogin(this.toggle);
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot? snapshotUserInfo;
  var username = "";

  signIn() async {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveuserEmailSharedPreferences(
          emailTextEditingController.text);
      databaseMethods
          .getUserbyUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        Object? loginData = snapshotUserInfo!.docs[0].data();
        if (loginData is Map<String, dynamic>) {
          HelperFunctions.saveuserNameSharedPreferences(
            loginData["name"],
          );
          setState(() {
            username = loginData["name"];
          });
        }
      });
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInwithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          BotToast.showText(
            borderRadius: BorderRadius.circular(10),
            textStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            contentColor: Colors.red,
            contentPadding: EdgeInsets.all(10),
            duration: Duration(seconds: 7),
            text: "Login of $username Successfully",
          );
          HelperFunctions.saveuserLoggedInSharedPreferences(false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => FruitiQee()));
        } else {
          setState(() {
            isLoading = false;
          });
          BotToast.showText(
            borderRadius: BorderRadius.circular(30),
            textStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            contentColor: Colors.red,
            contentPadding: EdgeInsets.all(10),
            duration: Duration(seconds: 7),
            text: "Login Failed due to account not found",
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/green_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: isLoading
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.red)),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 70),
                          child: Image.asset("assets/apple.gif",
                              width: 320, height: 280),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Please provide a valid email id";
                                },
                                controller: emailTextEditingController,
                                style: simpleTextFieldStyle(),
                                decoration: textFieldInputDecoration("Email"),
                              ),
                              TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val!.length > 6
                                      ? null
                                      : "Please provide Password more than 6 characters";
                                },
                                controller: passwordTextEditingController,
                                style: simpleTextFieldStyle(),
                                decoration:
                                    textFieldInputDecoration("Password"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        GestureDetector(
                          onTap: () {
                            signIn();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              color: Colors.red,
                            ),
                            child: Text(
                              "Login",
                              style: mediumTextStyle(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have account? ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  "Register Now",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
