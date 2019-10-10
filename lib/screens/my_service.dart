import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jee1rci/screens/home.dart';

class Myservice extends StatefulWidget {
  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
//Explict

//Method
  Widget signOutButton() {
    return IconButton(
      tooltip: 'ออก and Back Home',
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        processSignOut();
      },
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {});
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) => Home());
    Navigator.of(context)
        .pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
        actions: <Widget>[signOutButton()],
      ),
      body: Text('body'),
    );
  }
}
