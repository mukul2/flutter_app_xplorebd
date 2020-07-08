import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'ChamberDoctorsList.dart';
import 'OnlineDoctorsList.dart';
import '../login_view.dart';
import 'package:http/http.dart' as http;

class DeptForChamberDoc extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<DeptForChamberDoc> {
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
          title: new Text("Choose Departmemt"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChamberDoctorList((data[index]["id"]).toString())));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(00.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: new Text(
                    data[index]["name"],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ));
        },
      ),
    );
  }
}

List data_;

Widget DeptChamberDocWidget(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Department"),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, projectSnap) {
            return (data_ == null)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChamberDoctorListWidget(
                                            (projectSnap.data[index]["id"])
                                                .toString())));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(00.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: new Text(
                                projectSnap.data[index]["name"],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Future<List> getData() async {
  final http.Response response = await http.post(
    "http://telemedicine.drshahidulislam.com/api/" + 'department-list',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': AUTH_KEY,
    },
  );
  data_ = json.decode(response.body);

  return data_;
}
