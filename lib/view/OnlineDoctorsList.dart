import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'OnlineDoctorFullProfileView.dart';
import 'login_view.dart';
import 'package:http/http.dart' as http;



class OnlineDoctorList extends StatefulWidget {
   String selectedCategory;

   OnlineDoctorList(this.selectedCategory);
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<OnlineDoctorList> {

  List data;

  Future<String> getData() async {
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" + 'search-online-doctors',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(<String, String>{'department_id':  widget.selectedCategory}),



    );

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data);

    return "Success!";
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: new Text("Doctors"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return new InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OnlineDoctorFullProfileView(data[index]["id"],data[index]["name"])));
            },
            child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(00.0),
              ),
              child: ListTile(
                subtitle: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 20, 5),
                  child: new Text(data[index]["designation_title"],style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                title: Padding(
                  padding: EdgeInsets.fromLTRB(5, 15, 0, 5),
                  child: new Text(data[index]["name"],style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                leading: Image.network("http://telemedicine.drshahidulislam.com/"+data[index]["photo"],fit: BoxFit.fill),

              ),
            ),
          );
        },
      ),
    );
  }
}

