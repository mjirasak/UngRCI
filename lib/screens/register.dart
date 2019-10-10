import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jee1rci/screens/my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
// Explicit
  final formKey = GlobalKey<FormState>();
  String nameString, emailString, passwordString;

// Method

  Widget nameText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: Colors.purple,
        ),
        labelText: 'Display Name :',
        helperText: '่ใส่ชื่อType Your Name',
        hintText: 'English',
      ),
      onSaved: (value) {
        nameString = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: Colors.pink,
        ),
        labelText: 'Email :',
        helperText: '่Type Your Email',
        hintText: 'you@mail.com',
      ),
      onSaved: (value) {
        emailString = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: Colors.green,
        ),
        labelText: 'Password :',
        helperText: '่Type Your Password',
        hintText: 'More 6 Charactor',
      ),
      onSaved: (value) {
        passwordString = value.trim();
      },
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        print('You Click Upload');
        formKey.currentState.save();
        print('name = $nameString,email=$emailString,password=$passwordString');
        registerThread();
      },
    );
  }

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('Register Success');
      setUpDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('Title = $title , Message = $message');
      myAlert(title, message);
    });
  }

  Future<void> setUpDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nameString;
      response.updateProfile(userUpdateInfo);
      
    });
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().mainColor,
        title: Text('Register'),
        actions: <Widget>[registerButton()],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(50.0),
          children: <Widget>[
            nameText(),
            emailText(),
            passwordText(),
          ],
        ),
      ),
    );
  }
}
