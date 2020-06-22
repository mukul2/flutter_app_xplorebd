import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:appxplorebd/networking/Const.dart';
import 'package:appxplorebd/projPaypal/PaypalPayment.dart';
import 'package:appxplorebd/projPaypal/makePayment.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import '../login_view.dart';
import 'package:http/http.dart' as http;
List skill_info;
List education_info;
List chamber_info;
class ChamberDoctorFullProfileView extends StatefulWidget {
  String name;
  String photo;
  String designation_title;

  int id;

  ChamberDoctorFullProfileView(
      this.id, this.name, this.photo, this.designation_title);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<ChamberDoctorFullProfileView> {


  Future<String> getData() async {
    final http.Response response = await http.post(
      "http://telemedicine.drshahidulislam.com/api/" + 'doctor-education-chamber-info',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': AUTH_KEY,
      },
      body: jsonEncode(
          <String, String>{'dr_id': widget.id.toString()}),
    );

    this.setState(() {
      skill_info = json.decode(response.body)["skill_info"];
      education_info = json.decode(response.body)["education_info"];
      chamber_info = json.decode(response.body)["chamber_info"];
    });

 //   print(skill_info);

    return "Success!";
  }

  @override
  void initState() {
     this.getData();
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      //bottomSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: new Text(widget.name),

          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.work),
                text: "Chambers",
              ),
              Tab(icon: Icon(Icons.pan_tool), text: "Skills"),
              Tab(icon: Icon(Icons.school), text: "Education"),
            ],
          ),
        ),
        body: TabBarView(
          children: [Chambers((chamber_info)), Skills(skill_info), Educations(education_info)],
        ),
      ),
    );
  }
}

Widget Chambers(List chambers) {
  print("see now");
  print(chambers);
  return new ListView.builder(
    itemCount: chambers == null ? 0 : chambers.length,

    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: (){
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(chambers[index]["chamber_name"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((chambers[index]["address"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,
              trailing: RaisedButton(
                color: Colors.pink,
                child: Text("Book an Appointment",style: TextStyle(color: Colors.white),),
                onPressed: (){
                 // makePayment();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => PaypalPayment(),//startwork
                      )
                  );



                },
              ),
            ),
          ));
    },
  );
}
Widget Skills(List list) {
 // print(list);
  return new ListView.builder(
    itemCount: list == null ? 0 : list.length,

    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: (){
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(list[index]["body"],
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((list[index]["created_at"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,
            ),
          ));
    },
  );
}
Widget Educations(List education_info) {
  //print(education_info);
  return new ListView.builder(
    itemCount: education_info == null ? 0 : education_info.length,

    itemBuilder: (BuildContext context, int index) {
      return new InkWell(
          onTap: (){
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => OnlineDoctorList((data[index]["id"]).toString())));
          },
          child: Card(

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(00.0),
            ),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: new Text(education_info[index]["title"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              subtitle:Padding(
                padding:  EdgeInsets.fromLTRB(10, 00, 0, 10),
                child: new Text((education_info[index]["body"]).toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),),
              ) ,
            ),
          ));
    },
  );
}



//Widget tabBody(){
//  return
//}

//new SingleChildScrollView(
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//CircleAvatar(
//radius: 70,
//backgroundImage: NetworkImage(
//"http://telemedicine.drshahidulislam.com/" + widget.photo,
//)),
//Center(
//child: Padding(
//padding: EdgeInsets.all(10),
//child: Text(widget.designation_title),
//),
//
//),
//tabBody()
//
//
//],
//),
//)
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