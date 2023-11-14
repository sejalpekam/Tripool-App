import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MembersPage extends StatefulWidget {
  final bool isCreator;

  const MembersPage({Key? key, required this.isCreator}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  // Placeholder data for members and requests
  List<String> members = ['Member 1', 'Member 2', 'Member 3'];
  List<String> requests = ['Request 1', 'Request 2', 'Request 3'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void printdata(){
    _firestore.collection('Users').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print('Age: ${result.data()['Age']}');
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: requests.length,
                    itemBuilder: (BuildContext context, int index) {
                      String request = requests[index];

                      return ListTile(
                        title: Text(request),
                        subtitle: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to requested member profile
                                // Add your navigation logic here
                              },
                              child: Text('View Profile'),
                            ),
                            SizedBox(width: 8),
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
                      );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),

            // Members Section
            Text(
              'Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: members.length,
              itemBuilder: (BuildContext context, int index) {
                String member = members[index];
                bool isAdmin = index == 0; // Assuming the first member is the admin
            printdata();
                return ListTile(
                  title: Container(
                    width: 15, // Set the width as needed
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your logic for the member button
                      },
                      child: Text(member),
                    ),
                  ),
                  subtitle: isAdmin ? Text('Admin/Creator') : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
