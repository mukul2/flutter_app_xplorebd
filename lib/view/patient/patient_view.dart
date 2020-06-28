import 'dart:convert';
import 'dart:io' show Platform;

import 'package:appxplorebd/chat/model/chat_screen.dart';
import 'package:appxplorebd/chat/model/root_page.dart';
import 'package:appxplorebd/chat/service/authentication.dart';
import 'package:appxplorebd/networking/ApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'SubscriptionsActivityPatient.dart';
import 'departments_for_chamber_doc.dart';
import 'departments_for_online_doc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final String _baseUrl = "http://telemedicine.drshahidulislam.com/api/";

void mainP() {
  runApp(PatientAPP());
}

class PatientAPP extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      // Navigator.of(context).pop(true);
      // showThisToast("backpressed");

      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: _onWillpop,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(
            Icons.home,
            color: Colors.pink,
          ),
          title: new Text(
            'Home',
            style: TextStyle(color: Colors.pink),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.notification_important,
          color: Colors.pink,
        ),
        title: new Text(
          'Notification',
          style: TextStyle(color: Colors.pink),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.pink,
          ),
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.pink),
          )),
      BottomNavigationBarItem(
        icon: new Icon(
          Icons.calendar_today,
          color: Colors.pink,
        ),
        title: new Text(
          'Appointment',
          style: TextStyle(color: Colors.pink),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.book,
            color: Colors.pink,
          ),
          title: Text(
            'Blog',
            style: TextStyle(color: Colors.pink),
          ))
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(),
        ProjNotification(),
        Profile(),
        Appointment(),
        Blog(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillpop() {
      Navigator.of(context).pop(true);
      showThisToast("backpressed");

      return Future.value(false);
    }

    return AppWidget();
  }

  Widget AppWidget() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
      ),
      drawer: myDrawer(),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(
            "What are you looking for",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Card(
            child: ListTile(
              title: Text("Search for Doctor or Medicine"),
              leading: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeptListOnlineDocWidget(context),
                      ));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Image.asset(
                            "assets/doctor.png",
                            width: 30,
                            height: 30,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child:
                              const Text("I need to consult an Online Doctor"),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeptChamberDocWidget(context)));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Image.asset(
                            "assets/doctor.png",
                            width: 30,
                            height: 30,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text("Find the best Doctor near you"),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionViewPatient()));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Image.asset(
                            "assets/doctor.png",
                            width: 30,
                            height: 30,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text("Subscriptions"),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatListActivity()));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Image.asset(
                            "assets/doctor.png",
                            width: 30,
                            height: 30,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text("Chats"),
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
          ],
        )
      ],
    ));
  }
}

class ProjNotification extends StatefulWidget {
  @override
  _ProjNotificationState createState() => _ProjNotificationState();
}

class _ProjNotificationState extends State<ProjNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Notification"),
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Profile"),
    );
  }
}

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Appointments"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.done_all),
                text: "Confirmed",
              ),
              Tab(
                icon: Icon(Icons.done),
                text: "Pending",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ConfirmedList(),
            PedingList(),
          ],
        ),
      ),
    ));
  }
}

bool isConfirmedLoading = true;

bool isPendingLoading = true;

List data_Confirmd;

Widget ConfirmedList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchConfirmed(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  "http://telemedicine.drshahidulislam.com/" +
                                      projectSnap.data[index]["dr_info"]
                                          ["photo"],
                                )),
                                title: new Text(
                                  projectSnap.data[index]["dr_info"]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: new Text(
                                  projectSnap.data[index]["date"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Widget PedingList() {
  return Scaffold(
      body: FutureBuilder(
          future: fetchPeding(),
          builder: (context, projectSnap) {
            return (false)
                ? Center(child: CircularProgressIndicator())
                : new ListView.builder(
                    itemCount:
                        projectSnap.data == null ? 0 : projectSnap.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new InkWell(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                  "http://telemedicine.drshahidulislam.com/" +
                                      projectSnap.data[index]["dr_info"]
                                          ["photo"],
                                )),
                                title: new Text(
                                  projectSnap.data[index]["dr_info"]["name"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: new Text(
                                  projectSnap.data[index]["date"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ));
                    },
                  );
          }));
}

Future<dynamic> fetchConfirmed() async {
  showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': USER_ID, 'status': "1"}),
  );

  if (response.statusCode == 200) {
    data_Confirmd = json.decode(response.body);
    isConfirmedLoading = false;
    showThisToast("size " + (data_Confirmd.length).toString());
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<dynamic> fetchPeding() async {
  showThisToast("going to fetch confirmed list");
  final http.Response response = await http.post(
    _baseUrl + 'get-appointment-list',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': AUTH_KEY,
    },
    body: jsonEncode(
        <String, String>{'user_type': "patient", 'id': USER_ID, 'status': "0"}),
  );

  if (response.statusCode == 200) {
    data_Confirmd = json.decode(response.body);
    isConfirmedLoading = false;
    showThisToast("size " + (data_Confirmd.length).toString());
    return json.decode(response.body);
    // return LoginResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Blog"),
    );
  }
}

Widget myDrawer() {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: new Center(
            child: Text(
              "APP Name",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.pink,
          ),
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Facebook'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.facebook.com";

            // launch(url);
            //Share.share("https://www.facebook.com");
          },
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Youtube'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.youtube.com";

            // launch(url);
            //Share.share("https://www.youtube.com");
          },
        ),
        ListTile(
          leading: Icon(
            Icons.archive,
            color: Colors.deepOrange,
          ),
          title: Text('Twitter'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            const url = "https://www.twitter.com";

            // launch(url);
            // Share.share("https://www.twitter.com");
          },
        )
      ],
    ),
  );
}

class DeptOnlineActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Department (Online)"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
        ],
      ),
      body: DeptListOnlineDocWidget(context),
    );
  }
}

class ChatListActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: () {},
//          ),
        ],
      ),
      body: ChatListWidget(context),
    );
  }
}

Widget ChatListWidget(BuildContext context) {
  // String UID = USER_ID;
  String UID = "2";

  // FirebaseDatabase.instance.reference().child("xploreDoc").once()
  return Scaffold(
    body: FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child("xploreDoc")
            .child("lastChatHistory")
            .child(UID)
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.value != null) {
            List lists = [];
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              lists.add(values);
            });
            showThisToast((snapshot.data.value).toString());
            return lists.length > 0
                ? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          String chatRoom = createChatRoomName(
                             2,
                              11);
                          String own_id = "2";
                          String own_name = "Brie Larsson";
                          String own_photo = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSQkxmFzA0ekvItbzZh7n2irqs2nuSCK1K8-Q&usqp=CAU";
                          String partner_id = "11";
                          String partner_name = "Gal Gadot";
                          String parner_photo = "https://media1.popsugar-assets.com/files/thumbor/velDgOnJ4vMdXclF3iGXKBml2bA/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2018/01/11/067/n/1922153/2dcec7385a580320b4a0f3.56523054_edit_img_image_17359799_1515715881/i/Gal-Gadot-Makeup-Critics-Choice-Awards-2018.jpg";


                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(own_id,own_name,own_photo,partner_id,partner_name,parner_photo,chatRoom

                                  )));
                        },
                        child: Card(
                            child: (UID == (lists[index]["sender_id"]))
                                ? ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                      "http://telemedicine.drshahidulislam.com/" +
                                          lists[index]["receiver_photo"],
                                    )),
                                    title: Text(lists[index]["receiver_name"]),
                                    subtitle: (lists[index]["message_body"])
                                            .toString()
                                            .startsWith("http")
                                        ? Text("Photo")
                                        : Text((lists[index]["message_body"])
                                            .toString()),
                                  )
                                : ListTile(
                                    leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                      "http://telemedicine.drshahidulislam.com/" +
                                          lists[index]["sender_photo"],
                                    )),
                                    title: Text(lists[index]["sender_name"]),
                                    subtitle: (lists[index]["message_body"])
                                            .toString()
                                            .startsWith("http")
                                        ? Text("Photo")
                                        : Text((lists[index]["message_body"])
                                            .toString()),
                                  )),
                      );
                    })
                : Center(
                    child: Text("No Chat History"),
                  );
          }
          return Center(
            child: Text("No Chat History"),
          );
        }),
  );
}

String createChatRoomName(int one, int two) {
  if (one > two) {
    return (one.toString() + "-" + two.toString());
  } else {
    return (two.toString() + "-" + one.toString());
  }
}

Widget getChatList() {
  final dbRef = FirebaseDatabase.instance.reference().child("xploreDoc");
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
