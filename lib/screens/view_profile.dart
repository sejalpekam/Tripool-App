import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProfile extends StatefulWidget {
  final String CreatorId;

  const ViewProfile({Key? key, required this.CreatorId}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  String name = '';
  String age = '';
  String bio = '';
  String location = '';
  String email = '';
  int joinedActivitiesCount = 0;
  int createdActivitiesCount = 0;

  @override
  void initState() {
    super.initState();
    loadUserProfile(widget.CreatorId);
  }

  void loadUserProfile(String CreatorId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(CreatorId)
        .get();

    setState(() {
      name = userSnapshot['Name'];
      age = userSnapshot['Age'].toString();
      bio = userSnapshot['Description'];
      location = userSnapshot['Location'];
      email = userSnapshot['email'];
      joinedActivitiesCount =
          List.from(userSnapshot['Joined_Activities'] ?? []).length;
      createdActivitiesCount =
          List.from(userSnapshot['Created_Activities'] ?? []).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://example.com/profile-image.jpg',
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("Joined"),
                            SizedBox(height: 15),
                            Text(
                              joinedActivitiesCount.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("Created"),
                            SizedBox(height: 15),
                            Text(
                              createdActivitiesCount.toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Name: $name'),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Age: $age'),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Bio: $bio'),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Location: $location'),
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Email: $email'),
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
