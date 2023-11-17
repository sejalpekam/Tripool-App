import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tripool_app/app_state.dart';
import 'package:tripool_app/model/category.dart';
import 'package:tripool_app/model/event.dart';
import 'package:tripool_app/screens/activity_details.dart';
import 'package:tripool_app/widgets/event_widget.dart';
import 'package:tripool_app/widgets/loading_widget.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Activity').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data found');
        }

        

        List<Event> events = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          DateTime FromDateTime = data['From'].toDate();
          DateTime ToDateTime = data['To'].toDate();
          return Event(
            title: data['Activity_Name'],
            description: data['Activity_Description'],
            host: data['Creator'],
            location: data['Destination'],
            startdate: DateFormat('dd MMM yyyy').format(FromDateTime),
            starttime: DateFormat.jm().format(FromDateTime),
            enddate: DateFormat('dd MMM yyyy').format(ToDateTime),
            endtime: DateFormat.jm().format(ToDateTime),
            id: doc.id,
            categoryIds: [0, categoryindex[data["Category"]]],
          );
        }).toList();
        
        return Expanded(
          child: Container(
            margin: EdgeInsets.all(10) ,
            child: Consumer<AppState>(
              builder: (context, appState, _) => 
              SingleChildScrollView(
                child: Column(
                  children: <Widget> [
                    for (final event in events.where((e) => e.categoryIds.contains(appState.selectedCategoryId)))
                     InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(activityId: event.id),
                            ),
                          );
                        });
                      },
                      child: EventWidget(event: event),
                    )]),
              )
                
              ),
            ),
          );
        
      },
    );
  }
}
