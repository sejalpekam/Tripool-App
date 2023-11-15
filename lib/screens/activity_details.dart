import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tripool_app/widgets/loading_widget.dart';

class DetailsPage extends StatefulWidget {
  final String activityId;

  const DetailsPage({super.key, required this.activityId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
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
          var Members = snapshotDoc.get('Members') as List<dynamic>;
          var Requests = snapshotDoc.get('Requests') as List<dynamic>;
          print(Activity_Description);
          print(Category);
          print(Creator);

          var memberListButton = OutlinedButton(
              child: Icon(
                Icons.group,
                size: 100,
              ),
              onPressed: () {
                //TODO: Nav to MemberList when widget is done
                //   Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const MemberList(widget.activityId)),
                // );
              });

          var requestJoinButton = OutlinedButton(
            child: Text('Request Group'),
            onPressed: () async {
              final userDoc = FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currUser!.uid);
              final user = await userDoc.get();
              await userDoc.update({
                'Requested_Activities': [
                  ...user.get('Requested_Activities'),
                  widget.activityId
                ]
              });
            },
          );

          var actionButtons = [memberListButton, requestJoinButton];

          // if (Creator == currUser.uid) {
          //   actionButtons = [
          //     memberListButton,
          //     OutlinedButton(
          //         child: Text('Manage Group'),
          //         onPressed: () {
          //           //TODO: Manage group?
          //           //   Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(builder: (context) => const MemberList(widget.activityId)),
          //           // );
          //         }),
          //   ];
          // }

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
                  Text(
                    'Title : ' + Activity_Name,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text(
                    'Description: ' + Activity_Description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text(
                    'Conducted By: ' + Creator,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Proficiency of Host : ' + 'yo',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("From"),
                      Text(DateFormat.jms().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              From.toDate().millisecondsSinceEpoch))),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('To'),
                      Text(DateFormat.yMMMEd()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              To.toDate().millisecondsSinceEpoch))
                          .toString()),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text('Category : '),
                  Text(
                    Category,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text('Reqs : ' + Requests.toString()),
                  Text('Mems : ' + Members.toString()),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: actionButtons,
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
