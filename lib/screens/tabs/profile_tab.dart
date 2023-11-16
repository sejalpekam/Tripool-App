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

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserProfileData();
  }

  Future<void> getUserProfileData() async {
    var userData = await FirebaseFirestore.instance.collection('Users').doc(user?.uid).get();
    setState(() {
      userProfileData = userData;
      _setDataToControllers(userData);
    });
  }

  void _setDataToControllers(DocumentSnapshot userData) {
    Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
    _nameController.text = data['Name'] ?? '';
    _descriptionController.text = data['Description'] ?? '';
    _locationController.text = data['Location'] ?? '';
    _emailController.text = data['email'] ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  // edit function
   void editInfo() async {
    
    }

  // logout function:

  void logOut() async {
  await FirebaseAuth.instance.signOut();
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
            backgroundImage: NetworkImage(data['profileImageUrl'] ?? 'web/kisspng-gandalf-the-lord-of-the-rings-the-fellowship-of-t-gandalf-transparent-png-5a75ecd4c082e6.2548756615176777807885.jpg'),
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
          // Name just below the rating
          // Name and Activities Container in the same row

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name field with specified width
              SizedBox(
                width: 100, // Adjust the width as needed
                child: _buildEditableField('Name', _nameController),
              ),
              SizedBox(width: 80), // Optional spacing between fields
              SizedBox(
                width: 150,
                child: ActivitiesContainer(
                  joinedActivitiesCount: joinedActivitiesCount,
                  createdActivitiesCount: createdActivitiesCount,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),


          
          _buildEditableField('Description', _descriptionController),
          _buildEditableField('Location', _locationController),
          _buildEditableField('Email', _emailController),


          // Edit and logout button
          Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildEditButton(),
                      buildLogOutButton(),
                    ],
                  ),
        ],
      ),
    );
  }
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        // You can add validators or other properties as needed
      ),
    );
  }

  // edit button
  Widget buildEditButton() => Builder(
    builder: (context) => ElevatedButton(
      child: const Text('Edit'),
      onPressed: editInfo,
    ),
  );

  // logpout button
  Widget buildLogOutButton() => Builder(
    builder: (context) => ElevatedButton(
      child: const Text('Log Out'),
      onPressed: logOut, // Call the logOut method here
    ),
  );


}

// Activities Container classs
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
