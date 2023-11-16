import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripool_app/app_state.dart';
import 'package:tripool_app/model/category.dart';
import 'package:tripool_app/widgets/category_widget.dart';
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
          print(categories.where(((category) => category.name == Category)));

          var memberListButton = OutlinedButton(
              child: Icon(
                Icons.group,
                size: 40,
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
              print('UID: ${currUser?.uid}');
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
              await FirebaseFirestore.instance
                  .collection('Activity')
                  .doc(widget.activityId)
                  .update({
                'Requests': [...Requests, currUser.uid]
              });
            },
          );

          var actionButtons = [memberListButton, requestJoinButton];

          if (Creator == currUser?.uid) {
            actionButtons = [
              memberListButton,
              OutlinedButton(
                  child: Text('Manage Group'),
                  onPressed: () {
                    //TODO: Manage group?
                    //   Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const MemberList(widget.activityId)),
                    // );
                  }),
            ];
          }

          if (Requests.contains(currUser?.uid)) {
            actionButtons = [
              memberListButton,
              OutlinedButton(
                  onPressed: () async {
                    final userDoc = FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currUser!.uid);
                    final user = await userDoc.get();
                    await userDoc.update({
                      'Requested_Activities':
                          (user.get('Requested_Activities') as List<dynamic>)
                              .where((req) => req != widget.activityId),
                    });
                    await FirebaseFirestore.instance
                        .collection('Activity')
                        .doc(widget.activityId)
                        .update({
                      'Requests': (Requests).where((req) => req != currUser.uid)
                    });
                  },
                  child: Text('Withdraw Request'))
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      const Text('Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (final category in categories.where(
                                ((category) => category.name == Category)))
                              CategoryWidget(
                                category: category,
                                selectable: false,
                              )
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Divider(thickness: 1.5),
                  const Text('About',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<DocumentSnapshot>(
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

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.person, size: 24),
                              OutlinedButton(
                                  onPressed: () {
                                    // ON RPESS
                                  },
                                  child: Text(Name)),
                            ],
                          );
                        }),
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
