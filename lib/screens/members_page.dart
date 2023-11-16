import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersPage extends StatefulWidget {
  final bool isCreator;
  final String activityId;

  const MembersPage({Key? key, required this.isCreator, required this.activityId}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Placeholder data for requests
  List<String> requests = [];
  int membersCount = 0;

  // Fetch activity data from Firestore and store it in a map
  Future<Map<String, dynamic>> fetchActivityData() async {
    DocumentSnapshot activitySnapshot =
        await _firestore.collection('Activity').doc(widget.activityId).get();
    return activitySnapshot.data() as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchMembersData(List<String> memberIds) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('Users').where(FieldPath.documentId, whereIn: memberIds).get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<int> fetchMembersCount() async {
    Map<String, dynamic> activityData = await fetchActivityData();
    List<String> memberIds = List.from(activityData['Members'] ?? []);
    return memberIds.length;
  }

  @override
  void initState() {
    super.initState();
    fetchMembersCount().then((count) {
      setState(() {
        membersCount = count;
      });
    });
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
              FutureBuilder<Map<String, dynamic>>(
                future: fetchActivityData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, dynamic> activityData = snapshot.data ?? {};
                    requests = List.from(activityData['Requests'] ?? []);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requests (${requests.length})',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 256,
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
                                          // Text('${user['Name']}, Age: ${user['Age']}, Rating: ${user['Rating']}'),

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
                    );
                  }
                },
              ),

            // Members Section
            Text(
              'Members ($membersCount)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchActivityData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, dynamic> activityData = snapshot.data ?? {};
                    List<String> memberIds = List.from(activityData['Members'] ?? []);
                    
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchMembersData(memberIds),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<Map<String, dynamic>> membersData = snapshot.data ?? [];

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: membersData.map((user) {
                                String memberName = user['Name'];
                                String memberEmail = user['email'];
                                int memberAge = user['Age'];
                                int rating = user['Rating'];

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
                                          SizedBox(height: 8),
                                          Text('Rating: $rating')
                                        ],
                                      ),
                                      trailing: widget.isCreator
                                        ? IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              // Logic to delete the member
                                            },
                                          )
                                        : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}