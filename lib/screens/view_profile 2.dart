import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tripool_app/screens/tabs/create_tab.dart';

class ViewProfile extends StatefulWidget {
  final String CreatorId;
  const ViewProfile({super.key, required this.CreatorId});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  
  String name='';
  String age='';
  String bio='';
  String location='';
  String email = '';
  int joinedActivitiesCount = 0;
  int createdActivitiesCount = 0;


  @override
  void initState() {
    super.initState();
    // Load user profile data when the screen is initialized
    loadUserProfile(widget.CreatorId);
  }

  void loadUserProfile(CreatorId) async {
   DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(CreatorId)
          .get();

      setState(() {
        name = userSnapshot['Name'];
        age = userSnapshot['Age'].toString();
        bio = userSnapshot['Description'];
        location = userSnapshot['Location'];
        email = userSnapshot['email'];
        joinedActivitiesCount =
            List.from(userSnapshot['Joined_Activities'] ?? []).length;
        createdActivitiesCount =
            List.from(userSnapshot['Created_Activities'] ?? []).length;
      });

    }
    
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display profile image (replace with your implementation)
              CircleAvatar(
                radius: 50,
                // Add your profile image here
                backgroundImage: NetworkImage(
                  'https://example.com/profile-image.jpg',
                ),
              ),
              SizedBox(height: 25),
              // Display user details
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Joined"),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            joinedActivitiesCount.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Created"),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            createdActivitiesCount.toString(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
               SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors
                          .black, // You can customize the border color here
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // You can customize the border radius here
                  ),
                  child: Text('Name: ${name}')),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors
                          .black, // You can customize the border color here
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // You can customize the border radius here
                  ),
                  child: Text('Age: ${age}')),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors
                          .black, // You can customize the border color here
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // You can customize the border radius here
                  ),
                  child: Text('Bio: ${bio}')),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors
                          .black, // You can customize the border color here
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // You can customize the border radius here
                  ),
                  child: Text('Location: ${location}')),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors
                          .black, // You can customize the border color here
                    ),
                    borderRadius: BorderRadius.circular(
                        8.0), // You can customize the border radius here
                  ),
                  child: Text(
                      'Email: ${email}')),
              SizedBox(height: 32),
              // Edit button to update profile
             
            ],
          ),
        ),
      ),
    );
  }
}

