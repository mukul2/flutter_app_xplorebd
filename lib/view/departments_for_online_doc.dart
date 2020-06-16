import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'OnlineDoctorsList.dart';
import 'login_view.dart';
import 'package:http/http.dart' as http;


class DeptForOnlineDoc extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<DeptForOnlineDoc> {

  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" + 'department-list',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': AUTH_KEY,
      },

    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data[1]["name"]);

    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Departments"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,

        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
            },
            child: Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: new Text(data[index]["name"],
                style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ));
        },
      ),
    );
  }
}

