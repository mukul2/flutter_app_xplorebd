import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'SubscriptionsActivityPatient.dart';
import 'departments_for_chamber_doc.dart';
import 'departments_for_online_doc.dart';

void main() => runApp(PatientAPP());

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

      onWillPop:_onWillpop,
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
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
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
                              builder: (context) => DeptListOnlineDocWidget(context),));
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
                              child: const Text(
                                  "Find the best Doctor near you"),
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
                              builder: (context) => DeptForChamberDoc()));
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
      child: Text("Appointment"),
    );
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
