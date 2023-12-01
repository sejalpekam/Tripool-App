import 'package:flutter/material.dart';

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
                title: Text('Go to the "Explore Tab", third icon in the bottom row. Explore the activities available. Click on the activity to find more details. Hit the "Request Group" button if you wish to join the activity. This will send a notification to the "Creator" of the activity. Once you are approved by the "Creator" you would have successfully joined the group.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I create a group?'),
            children: <Widget>[
              ListTile(
                title: Text('Click on the "Create" icon, the second icon in the bottom row. Fill in the details such as name of the activity, activity description, date and time, and activity location. Hit "Submit" to successfully create an activity.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How to accept or reject potential group members?'),
            children: <Widget>[
              ListTile(
                title: Text('Go to the "Schedule" tab, the first icon in the bottom row. Find the activity you would like to manage. Click on it. You\'ll see a button with the group icon. Click on it to manage the members. You can click on tick mark to approve the request, "X" to reject request and click the dustbin icon to remove an approved member.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}