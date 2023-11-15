import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripool_app/widgets/loading_widget.dart';

class MemberList extends StatefulWidget {
  final String activityId;

  const MemberList({super.key, this.activityId});

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Member List')),
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
          var Members = snapshotDoc.get('Members');
          print(Activity_Name);
          print(Activity_Description);
          print(Category);
          print(Creator);
          print(From_Date);
          print(From_Time);
          print(To_Date);
          print(To_Time);


           return ListView(
            children: members.map((String memberId) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(memberId)
                    .snapshots(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget();
                  }

                  final snapshotDoc = snapshot.data!;
                  final name = snapshotDoc.get('Name');

                  return child: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
