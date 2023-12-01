import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripool_app/app_state.dart';
import 'package:tripool_app/model/category.dart';
import 'package:tripool_app/screens/members_page.dart';
import 'package:tripool_app/screens/tabs/edit_tab.dart';
import 'package:tripool_app/screens/view_profile.dart';
import 'package:tripool_app/widgets/category_widget.dart';
import 'package:tripool_app/widgets/loading_widget.dart';

class DetailsPage extends StatefulWidget {
  final String activityId;

  const DetailsPage({super.key, required this.activityId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

// Method to check for pending requests, for notification arrays
Stream<bool> hasNotifications(String activityId) {
  final currentUser = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('Activity')
      .doc(activityId)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        bool isCreator = currentUser?.uid == data?['Creator'];
        bool inNotifAcceptRequest = (data?['Notif_AcceptedRequest'] as List<dynamic>? ?? []).contains(currentUser?.uid);
        bool inNotifRemovedMembers = (data?['Notif_RemovedMembers'] as List<dynamic>? ?? []).contains(currentUser?.uid);
        bool inNotifRequests = (data?['Notif_Request'] as List<dynamic>? ?? []).isNotEmpty;
        bool inNotifLeftActivity = (data?['Notif_LeftActivity'] as List<dynamic>? ?? []).isNotEmpty;

        return (isCreator && (inNotifRequests || inNotifLeftActivity)) ||
               (!isCreator && (inNotifAcceptRequest || inNotifRemovedMembers));
      });
}



class _DetailsPageState extends State<DetailsPage> {
  
  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: Text('Activity Details')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Activity')
            .doc(widget.activityId)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          }

          final snapshotDoc = snapshot.data!;

          String Activity_Name = snapshotDoc.get('Activity_Name');
          String Activity_Description = snapshotDoc.get('Activity_Description');
          String Category = snapshotDoc.get('Category');
          String Creator = snapshotDoc.get('Creator');
          Timestamp From = snapshotDoc.get('From') as Timestamp;
          Timestamp To = snapshotDoc.get('To') as Timestamp;
          String Destination = snapshotDoc.get('Destination');
          var Members = snapshotDoc.get('Members') as List<dynamic>;
          var Requests = snapshotDoc.get('Requests') as List<dynamic>;
          print(Activity_Description);
          print(Category);
          print(Creator);
          print(categories.where(((category) => category.name == Category)));

          // Update memberListButton with StreamBuilder
          Widget memberListButton = StreamBuilder<bool>(
            stream: hasNotifications(widget.activityId),
            builder: (context, requestSnapshot) {
             bool hasNotifications = requestSnapshot.data ?? false;
              return OutlinedButton(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.group, size: 40),
                    if (hasNotifications) // Show red dot if there are requests and the user is the creator
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  final isCreator = Creator == currUser?.uid;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MembersPage(
                              isCreator: isCreator,
                              activityId: widget.activityId,
                            )),
                  );
                },
              );
            },
          );

          var requestJoinButton = OutlinedButton(
            child: Text('Request Group'),
            onPressed: () async {
              print('UID: ${currUser?.uid}');
              final userDoc = FirebaseFirestore.instance.collection('Users').doc(currUser!.uid);
              final activityDoc = FirebaseFirestore.instance.collection('Activity').doc(widget.activityId);

              final user = await userDoc.get();
              final activity = await activityDoc.get();

              // Update the User's Requested_Activities
              await userDoc.update({
                'Requested_Activities': [
                  ...user.get('Requested_Activities'),
                  widget.activityId
                ]
              });

              // Update the Activity's Requests
              await activityDoc.update({
                'Requests': FieldValue.arrayUnion([currUser.uid])
              });

              // Also update the Notif_Request array in the Activity document
              await activityDoc.update({
                'Notif_Request': FieldValue.arrayUnion([currUser.uid])
              });
            },
          );


          var actionButtons = [memberListButton, requestJoinButton];

          if (Requests.contains(currUser?.uid)) {
            actionButtons = [
              memberListButton,
              OutlinedButton(
  onPressed: () async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userDocRef = FirebaseFirestore.instance.collection('Users').doc(currentUser!.uid);
    final activityDocRef = FirebaseFirestore.instance.collection('Activity').doc(widget.activityId);

    final user = await userDocRef.get();
    final activity = await activityDocRef.get();
    List<dynamic> members = activity.get('Members') as List<dynamic>;
    List<dynamic> notifRequests = activity.get('Notif_Request') as List<dynamic>;

    // Update Notif_LeftActivity if the user is a member of the activity
    if (members.contains(currentUser.uid)) {
      await activityDocRef.update({
        'Notif_LeftActivity': FieldValue.arrayUnion([currentUser.uid])
      });
    }

    // Remove user from Requested_Activities
    await userDocRef.update({
      'Requested_Activities': (user.get('Requested_Activities') as List<dynamic>).where((req) => req != widget.activityId).toList(),
    });

    // Remove user from Activity's Requests
    await activityDocRef.update({
      'Requests': (activity.get('Requests') as List<dynamic>).where((req) => req != currentUser.uid).toList(),
    });

    

    // Update Notif_Request if the user is in Notif_Request
    if (notifRequests.contains(currentUser.uid)) {
      await activityDocRef.update({
        'Notif_Request': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  },
  child: Text('Withdraw Request')
)



            ];
          }

          if (Members.contains(currUser?.uid)) {
            actionButtons = [
              memberListButton,
              OutlinedButton(
                  onPressed: () async {
                    // Notificaton part
                    final currentUser = FirebaseAuth.instance.currentUser;
                    final activityDocRef = FirebaseFirestore.instance.collection('Activity').doc(widget.activityId);
                    // Notificaton part

                    final userDoc = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currUser!.uid);
                    final user = await userDoc.get();
                    await userDoc.update({
                      'Joined_Activities':
                          (user.get('Joined_Activities') as List<dynamic>)
                              .where((req) => req != widget.activityId),
                    });
                    await FirebaseFirestore.instance
                        .collection('Activity')
                        .doc(widget.activityId)
                        .update({
                      'Members': (Members).where((req) => req != currUser.uid)
                    });

                    // Notificaton: insert to Notif_LeftActivity
                     await activityDocRef.update({
                      'Notif_LeftActivity': FieldValue.arrayUnion([currentUser?.uid])
                    });
                  },
                  child: Text('Leave Group'))
            ];
          }

          if (Creator == currUser?.uid) {
            actionButtons = [
              memberListButton,
              OutlinedButton(
                  child: Text('Edit Activity'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditActivityTab(activityId: widget.activityId)),
                    );
                  }),
            ];
          }

          // [
          //                       ElevatedButton(
          //                         child: Text('Join Now'),
          //                         onPressed: isCountEqual
          //                             ? () async {
          //                                 _launchURL(snapshotDoc.get('sigLink'));
          //                               }
          //                             : null,
          //                       ),
          //                       ElevatedButton(
          //                         child: Text('Interested'),
          //                         onPressed: () async {
          //                           await FirebaseFirestore.instance
          //                               .collection('sigs')
          //                               .doc(widget.sigId)
          //                               .update({
          //                             'interestedCount':
          //                                 snapshotDoc.get('interestedCount') + 1
          //                           });

          //                           await FirebaseFirestore.instance
          //                               .collection('users')
          //                               .doc(FirebaseAuth.instance.currentUser!.uid)
          //                               .collection('interestedSigs')
          //                               .doc(widget.sigId)
          //                               .set({
          //                             'sigId': widget.sigId,
          //                             'sigTitle': snapshotDoc.get('sigTitle'),
          //                           });

          //                           print(snapshotDoc.get('interestedCount'));
          //                           print(snapshotDoc.get('sigCount'));
          //                           if (snapshotDoc.get('interestedCount') ==
          //                               snapshotDoc.get('sigCount')) {
          //                             print('this is working');
          //                             await FirebaseFirestore.instance
          //                                 .collection('sigs')
          //                                 .doc(widget.sigId)
          //                                 .update({'isConfirmed': true});
          //                           }
          //                         },
          //                       ),
          //                     ],

          return Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(Activity_Name,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold))
                  ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.jm().format(From.toDate())),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.yMMMEd()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    From.toDate().millisecondsSinceEpoch))
                                .toString()),
                          )
                        ],
                      ),
                      const Icon(Icons.arrow_forward, size: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.jm().format(To.toDate())),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.yMMMEd()
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    To.toDate().millisecondsSinceEpoch))
                                .toString()),
                          )
                        ],
                      ),
                    ],
                  ),
                  // Add this SizedBox for spacing
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_pin, size: 32),
                      Text(
                        Destination,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(children: [
                          const Text('Category',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          CategoryWidget(
                            category: categories.firstWhere(
                                (element) => element.name == Category),
                            selectable: false,
                          ),
                        ]),
                        SizedBox(
                          width: 40,
                        ),
                        Column(children: [
                          const Text('Creator',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(Creator)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingWidget();
                                }

                                final snapshotDoc = snapshot.data!;

                                String Name = snapshotDoc.get('Name');

                                return TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewProfile(CreatorId: Creator,)),
                                    );
                                  },
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 10),
                                          child: Icon(Icons.person, size: 45),
                                        ),
                                        Text(Name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14))
                                      ]),
                                );
                              }),
                        ]),
                      ],
                    ),
                  ),
                  Divider(thickness: 1.5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: const Text('About Activity',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Text(
                    Activity_Description,
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 48.0, 8.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: actionButtons,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
