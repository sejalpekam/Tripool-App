import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQ Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FAQPage(),
    );
  }
}

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
      ),
      body: ListView(
        children: <Widget>[
          ExpansionTile(
            title: Text('How do I join an activity?'),
            children: <Widget>[
              ListTile(
                title: Text('Click on the homescreen icon from the middle button of the task bar at the bottom of the screen. From this interface, click “JOIN GROUP” in order find a group to search for and request to join'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I create a group?'),
            children: <Widget>[
              ListTile(
                title: Text('Click on the homescreen icon from the middle button of the task bar at the bottom of the screen. From here, click “CREATE GROUP”. On this screen, fill out the fields for “name”, “description” and “destination” as well as choosing a category at the top. Then, you may click “submit” to post the activity.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How to accept or reject potential group members?'),
            children: <Widget>[
              ListTile(
                title: Text('From the “Your Trips” screen, click on “Created” and navigate to the activity created that you are looking to manage and click on it. From this screen, click on the person icon next to the “Manage Group” button at the bottom. From here, you may accept or reject members, as well as view their profiles by clicking on their names, and using the check or X buttons.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}