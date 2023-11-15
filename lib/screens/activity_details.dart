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
          String From_Date = snapshotDoc.get('From_Date');
          String From_Time = snapshotDoc.get('From_Time');
          String To_Date = snapshotDoc.get('To_Date');
          String To_Time = snapshotDoc.get('To_Time');
          print(Activity_Name);
          print(Activity_Description);
          print(Category);
          print(Creator);
          print(From_Date);
          print(From_Time);
          print(To_Date);
          print(To_Time);

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
                    'Title : ' + snapshotDoc.get('sigTitle'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text(
                    'Description: ' + snapshotDoc.get('sigDesc'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text(
                    'Conducted By: ' + snapshotDoc.get('sigByName'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Proficiency of Host : ' + snapshotDoc.get('proficiency'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date of SIG"),
                      Text(DateFormat.jms().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              snapshotDoc.get('sigDateTime').seconds * 1000))),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Time of SIG'),
                      Text(DateFormat.yMMMEd()
                          .format(DateTime.fromMillisecondsSinceEpoch(
                              snapshotDoc.get('sigDateTime').seconds * 1000))
                          .toString()),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text('Topics : '),
                  Text(
                    snapshotDoc.get('topics'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text('Registered Enthusiasts Count : ' +
                      snapshotDoc.get('interestedCount').toString()),
                  Text('Join Now would be activated after : ' +
                      (snapshotDoc.get('sigCount') -
                              snapshotDoc.get('interestedCount'))
                          .toString() +
                      ' entries'),
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
