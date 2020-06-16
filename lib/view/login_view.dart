import 'dart:convert';

import 'package:appxplorebd/models/login_response.dart';
import 'package:appxplorebd/view/patient_view.dart';
import 'package:flutter/material.dart';
import 'package:appxplorebd/networking/Repsonse.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String email, password;
  String myMessage = "Login";

  Widget StandbyWid = Text("Login");
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            initialValue: "m@gmail.com",
            validator: (value) {
              email = value;
              if (value.isEmpty) {
                return 'Please enter Email';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: "123456",
            validator: (value) {
              password = value;
              if (value.isEmpty) {
                return 'Please enter Password';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  setState(() {
                    StandbyWid = Text("Please wait");
                  });

                  LoginResponse loginResponse =
                      await performLogin(email, password);
                  showThisToast(loginResponse.message);
                  setState(() {
                    StandbyWid = Text(loginResponse.message);
                  });
                  if (loginResponse.status) {
                    AUTH_KEY ="Bearer "+ loginResponse.accessToken;
                    if (loginResponse.userInfo.userType.contains("d")) {
                      //doctor
                    } else if (loginResponse.userInfo.userType.contains("p")) {
                      //patient
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => PatientAPP()));
                    }else {
                      //unknwon user
                      showThisToast("Unknown user");

                    }
                  } else {
                    showThisToast(loginResponse.message);
                  }
                }
              },
              child: StandbyWid,
            ),
          ),
        ],
      ),
    );
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
