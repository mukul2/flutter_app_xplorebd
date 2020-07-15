import 'dart:convert';

import 'package:appxplorebd/models/login_response.dart';
import 'doctor/doctor_view.dart';
import 'file:///D:/downloads/TM/flutter_app_xplorebd/lib/view/patient/patient_view.dart';
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
      color: Colors.blueAccent,
      title: appTitle,
      home: Scaffold(
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
  String myMessage = "Submit";

  Widget StandbyWid = Text(
    "Login",
    style: TextStyle(color: Colors.white),
  );
  LoginResponse _loginResponse;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Telemedicine",
            style: TextStyle(
                color: Color(0xFF34448c),
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              initialValue: "p@gmail.com",
              validator: (value) {
                email = value;
                if (value.isEmpty) {
                  return 'Please enter Email';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              initialValue: "123456",
              validator: (value) {
                password = value;
                if (value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: SizedBox(
                height: 50,
                width: double.infinity, // match_parent
                child: RaisedButton(
                  color: Color(0xFF34448c),
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
                      print(loginResponse.toString());
                      showThisToast(loginResponse.message);
                      setState(() {
                        StandbyWid = Text(loginResponse.message);
                      });
                      if (loginResponse.status) {
                        AUTH_KEY = "Bearer " + loginResponse.accessToken;
                        USER_ID = loginResponse.userInfo.id.toString();
                        if (loginResponse.userInfo.userType.contains("d")) {
                          showThisToast("doctor");
                          DOC_HOME_VISIT = loginResponse.userInfo.home_visits;
                          //doctor
                          mainD();
                        } else if (loginResponse.userInfo.userType
                            .contains("p")) {
                          //patient
                          showThisToast("patient");

                          mainP();
//                      Navigator.push(
//                          context, MaterialPageRoute(builder: (context) => PatientAPP()));
                        } else {
                          //unknwon user
                          showThisToast("Unknown user");
                        }
                      } else {
                        showThisToast(loginResponse.message);
                      }
                    }
                  },
                  child: StandbyWid,
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: SizedBox(
                height: 50,
                width: double.infinity, // match_parent
                child: RaisedButton(
                  color: Colors.deepPurple,

                  child:  Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          )
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
