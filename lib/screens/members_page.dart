import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripool_app/screens/view_profile.dart';

class MembersPage extends StatefulWidget {
  final bool isCreator;
  final String activityId;

  const MembersPage({
    Key? key,
    required this.isCreator,
    required this.activityId,
  }) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Placeholder data for requests
  List<String> requests = [];

  // Fetch activity data from Firestore and store it in a map
  Stream<Map<String, dynamic>> fetchActivityData() {
    final activitySnapshot =
        _firestore.collection('Activity').doc(widget.activityId).snapshots();

    return activitySnapshot.map((event) => event.data()!);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchMembersData(
      List<String> memberIds) async {
    final querySnapshot = await _firestore
        .collection('Users')
        .where(FieldPath.documentId, whereIn: memberIds)
        .get();
    return querySnapshot.docs.toList();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchRequestersData(
      List<String> requesterIds) async {
    final querySnapshot = await _firestore
        .collection('Users')
        .where(FieldPath.documentId, whereIn: requesterIds)
        .get();
    return querySnapshot.docs.toList();
  }

  Stream<int> fetchMembersCount() {
    return fetchActivityData()
        .map((event) => List.from(event['Members'] ?? []).length);
  }

  Stream<int> fetchRequestsCount() {
    return fetchActivityData()
        .map((event) => List.from(event['Requests'] ?? []).length);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> clearNotifications() async {
    await _firestore.collection('Activity').doc(widget.activityId).update({
      'Notif_Request': [],
      'Notif_LeftActivity': [],
    });
  }


  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    Future<void> updateOrClearNotifications() async {
      final activityDocRef = FirebaseFirestore.instance.collection('Activity').doc(widget.activityId);
      final activitySnapshot = await activityDocRef.get();
      final activityData = activitySnapshot.data();

      if (currentUser?.uid == activityData?['Creator']) {
        // If current user is the creator, clear specific notification arrays
        await activityDocRef.update({
          'Notif_Request': [],
          'Notif_LeftActivity': [],
        });
      } else {
        // If current user is a member but not the creator
        await activityDocRef.update({
          'Notif_AcceptedRequest': FieldValue.arrayRemove([currentUser?.uid]),
          'Notif_RemovedMembers': FieldValue.arrayRemove([currentUser?.uid]),
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
      title: Text('Members Page'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () async {
          // await updateOrClearNotifications();
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
              StreamBuilder<Map<String, dynamic>>(
                stream: fetchActivityData(),
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
                        StreamBuilder<int>(
                          stream: fetchRequestsCount(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Text('Requests (0)');
                            }
                            return Text(
                              'Requests (${snapshot.data})',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        SizedBox(
                          height: 256,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: requests.map((request) {
                                return FutureBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                  future: _firestore
                                      .collection('Users')
                                      .doc(request)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      Map<String, dynamic> userData =
                                          (snapshot.data as DocumentSnapshot<
                                                      Map<String, dynamic>>)
                                                  .data() ??
                                              {};
                                      String userName = userData['Name'];
                                      int userAge = userData['Age'];

                                      return Card(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewProfile(
                                                        CreatorId: request,
                                                      )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Name: $userName' +
                                                    (widget.isCreator &&
                                                            request ==
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid
                                                        ? ' (Creator)'
                                                        : '')),
                                                Text('Age: $userAge'),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () async {
                                                          final userDoc = FirebaseFirestore.instance.collection('Users').doc(snapshot.data!.id);

                                                          // Accept the request
                                                          await userDoc.update({
                                                            'Requested_Activities': (userData['Requested_Activities'] as List<dynamic>).where((req) => req != widget.activityId),
                                                          });
                                                          await userDoc.update({
                                                            'Joined_Activities': [...(userData['Joined_Activities'] as List<dynamic>), widget.activityId],
                                                          });
                                                          await FirebaseFirestore.instance.collection('Activity').doc(widget.activityId).update({
                                                            'Requests': (activityData['Requests'] as List<dynamic>).where((req) => req != snapshot.data!.id),
                                                            'Members': [...(activityData['Members'] as List<dynamic>), snapshot.data!.id],
                                                            'Notif_AcceptedRequest': FieldValue.arrayUnion([snapshot.data!.id]), // Add member to Notif_AcceptedRequest
                                                          });
                                                        },
                                                        child: Text('Accept'),
                                                      ),
                                                    SizedBox(width: 8),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        final userDoc = FirebaseFirestore.instance.collection('Users').doc(snapshot.data!.id);

                                                        // Reject the request
                                                        await userDoc.update({
                                                          'Requested_Activities': (userData['Requested_Activities'] as List<dynamic>).where((req) => req != widget.activityId),
                                                        });
                                                        await FirebaseFirestore.instance.collection('Activity').doc(widget.activityId).update({
                                                          'Requests': (activityData['Requests'] as List<dynamic>).where((req) => req != snapshot.data!.id),
                                                          'Notif_RemovedMembers': FieldValue.arrayUnion([snapshot.data!.id]), // Add member to Notif_RemovedMembers
                                                        });
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
                                    }
                                  },
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
            StreamBuilder<Object>(
              stream: fetchMembersCount(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Text('Members (0)');
                }
                return Text(
                  'Members (${snapshot.data})',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              },
            ),
            Expanded(
              child: StreamBuilder<Map<String, dynamic>>(
                stream: fetchActivityData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Map<String, dynamic> activityData = snapshot.data ?? {};
                    List<String> memberIds =
                        List.from(activityData['Members'] ?? []);

                    return FutureBuilder<
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                      future: fetchMembersData(memberIds),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final membersData = snapshot.data ?? [];

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: membersData.map((user) {
                                print('user ==> ${user.data()}');
                                final userData = user.data();
                                String memberName = userData['Name'];
                                String memberEmail = userData['email'];
                                int memberAge = userData['Age'];
                                // int rating = userData['Rating'];

                                return Card(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewProfile(
                                                  CreatorId: user.id,
                                                )),
                                      );
                                    },
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Name: $memberName' +
                                              (user.id ==
                                                      activityData['Creator']
                                                  ? ' (Creator)'
                                                  : '')),
                                          SizedBox(height: 8),
                                          Text('Email: $memberEmail'),
                                          SizedBox(height: 8),
                                          Text('Age: $memberAge'),
                                          SizedBox(height: 8),
                                          // Text('Rating: $rating'),
                                        ],
                                      ),
                                      trailing: widget.isCreator &&
                                              (user.id !=
                                                  FirebaseAuth.instance
                                                      .currentUser?.uid)
                                          ? IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () async {
                                                final userDoc =
                                                    FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(user.id);

                                                await userDoc.update({
                                                  'Joined_Activities': (userData[
                                                              'Joined_Activities']
                                                          as List<dynamic>)
                                                      .where((req) =>
                                                          req !=
                                                          widget.activityId),
                                                });
                                                await FirebaseFirestore.instance
                                                    .collection('Activity')
                                                    .doc(widget.activityId)
                                                    .update({
                                                  'Members':
                                                      (activityData['Members']
                                                              as List<dynamic>)
                                                          .where((req) =>
                                                              req != user.id)
                                                });
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
