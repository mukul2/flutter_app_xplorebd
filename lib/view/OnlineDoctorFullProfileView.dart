
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'login_view.dart';
import 'package:http/http.dart' as http;

class OnlineDoctorFullProfileView extends StatefulWidget {
  String name;
  int id;



  OnlineDoctorFullProfileView(this.id,this.name);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<OnlineDoctorFullProfileView> {

//  List data;
//
//  Future<String> getData() async {
//    final http.Response response = await http.post(
//      "http://telemedicine.drshahidulislam.com/api/" + 'search-online-doctors',
//      headers: <String, String>{
//        'Content-Type': 'application/json; charset=UTF-8',
//        'Authorization': AUTH_KEY,
//      },
//      body: jsonEncode(
//          <String, String>{'department_id': widget.selectedCategory}),
//    );
//
//    this.setState(() {
//      data = json.decode(response.body);
//    });
//
//    print(data);
//
//    return "Success!";
//  }

  @override
  void initState() {
   // this.getData();

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          new AppBar(title: new Text(widget.name), backgroundColor: Colors.blue),

    );
  }
}
