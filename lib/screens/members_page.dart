import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersPage extends StatefulWidget {
  final bool isCreator;

  const MembersPage({Key? key, required this.isCreator}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  // Placeholder data for requests
  List<String> requests = [
    'Request 1', 'Request 2', 'Request 3', 'Request 4', 'Request 5',
    'Request 6', 'Request 7', 'Request 8', 'Request 9', 'Request 10'
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user data from Firestore and store it in a list
  Future<List<Map<String, dynamic>>> fetchUserData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Users').get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Requests Section (only for the Creator)
            if (widget.isCreator)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 256, // Set the height as needed
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: requests.map((request) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                // Add logic for when a request card is tapped
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(request),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Logic to accept the requested member
                                          },
                                          child: Text('Accept'),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Logic to reject the requested member
                                          },
                                          child: Text('Reject'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),

            // Members Section
            Text(
              'Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>> userData = snapshot.data ?? [];

                      return Column(
                        children: userData.map((user) {
                          String memberName = user['Name'];
                          String memberEmail = user['email'];
                          int memberAge = user['Age'];
                          bool isAdmin = user == userData.first;

                          return Card(
                            child: InkWell(
                              onTap: () {
                                // Add logic for when a member card is tapped
                              },
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(memberName),
                                    SizedBox(height: 8),
                                    Text(memberEmail),
                                    SizedBox(height: 8),
                                    Text('Age: $memberAge'),
                                  ],
                                ),
                                subtitle: isAdmin ? Text('Admin/Creator') : null,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
