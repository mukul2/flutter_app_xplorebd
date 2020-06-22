import 'package:flutter/material.dart';

import 'view/login_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chucky Norris',
        home: LoginUI()); // define it once at root level.
  }
}
