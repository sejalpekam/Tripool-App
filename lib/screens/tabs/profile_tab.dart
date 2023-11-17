import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  User? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? userProfileData;

  @override
  void initState() {
    super.initState();
    getUserProfileData();
  }

  Future<void> getUserProfileData() async {
    var userData = await FirebaseFirestore.instance.collection('Users').doc(user?.uid).get();
    setState(() {
      userProfileData = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userProfileData == null) {
      return Center(child: CircularProgressIndicator());
    }

    Map<String, dynamic> data = userProfileData!.data() as Map<String, dynamic>;
    int joinedActivitiesCount = List.from(data['Joined_Activities'] ?? []).length;
    int createdActivitiesCount = List.from(data['Created_Activities'] ?? []).length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 70),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(data['profileImageUrl'] ?? 'default_image_url.jpg'),
          ),
          SizedBox(height: 10),
          // Rating just below the image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber),
              Text('${data['Rating'] ?? 0}/5'),
            ],
          ),
          SizedBox(height: 10),
          // Display User Information
          _buildInfoField('Name', data['Name']),
          _buildInfoField('Description', data['Description']),
          _buildInfoField('Location', data['Location']),
          _buildInfoField('Email', data['email']),

          ActivitiesContainer(
            joinedActivitiesCount: joinedActivitiesCount,
            createdActivitiesCount: createdActivitiesCount,
          ),
        ],
      ),
    );
  }

  // Function to build non-editable info field
  Widget _buildInfoField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}

// Activities Container class
class ActivitiesContainer extends StatelessWidget {
  final int joinedActivitiesCount;
  final int createdActivitiesCount;

  const ActivitiesContainer({
    Key? key,
    required this.joinedActivitiesCount,
    required this.createdActivitiesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Set a fixed width for the container
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActivityCount('Joined', joinedActivitiesCount),
              _buildActivityCount('Created', createdActivitiesCount),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCount(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
