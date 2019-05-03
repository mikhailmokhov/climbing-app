import 'package:climbing/widgets/gymslist.dart';
import 'package:flutter/material.dart';

const String APP_KEY = 'AIzaSyCJ4u7HC3AsvOMS_4w-mdkhLOP_deCLBcc';
const String KEYWORD = 'climbing%20gym';
const String LOCATION = '43.640454,-79.380488';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climbing routes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GymList(),
    );
  }
}