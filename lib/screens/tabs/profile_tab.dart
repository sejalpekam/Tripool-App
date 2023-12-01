import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  int joinedActivitiesCount = 0;
  int createdActivitiesCount = 0;

  @override
  void initState() {
    super.initState();
    // Load user profile data when the screen is initialized
    loadUserProfile();
  }

  void loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve user profile data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      // Update text controllers with the retrieved data
      setState(() {
        nameController.text = userSnapshot['Name'] ?? '';
        ageController.text = userSnapshot['Age'].toString() ?? '';
        bioController.text = userSnapshot['Description'] ?? '';
        locationController.text = userSnapshot['Location'] ?? '';
        joinedActivitiesCount =
            List.from(userSnapshot['Joined_Activities'] ?? []).length;
        createdActivitiesCount =
            List.from(userSnapshot['Created_Activities'] ?? []).length;
      });
    }
  }

  void updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Update user profile data in Firestore
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'Name': nameController.text,
          'Age': int.parse(ageController.text),
          'Description': bioController.text,
          'Location': locationController.text,
          // Add more fields as needed
        });

        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
        loadUserProfile();
      } catch (e) {
        // Handle errors
        print('Error updating profile: $e');
      }
    }
  }

  void logOut() async {
    await FirebaseAuth.instance.signOut();
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
                  child: Text('Name: ${nameController.text}')),
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
                  child: Text('Age: ${ageController.text}')),
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
                  child: Text('Bio: ${bioController.text}')),
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
                  child: Text('Location: ${locationController.text}')),
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
                      'Email: ${FirebaseAuth.instance.currentUser?.email}')),
              SizedBox(height: 32),
              // Edit button to update profile
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditProfileDialog(
                          nameController: nameController,
                          ageController: ageController,
                          bioController: bioController,
                          locationController: locationController,
                          onUpdatePressed: updateProfile,
                        ),
                      );
                    },
                    child: Text('Edit Profile'),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton(
                    child: const Text('Log Out'),
                    onPressed: logOut, // Call the logOut method here
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController bioController;
  final TextEditingController locationController;
  final VoidCallback onUpdatePressed;

  EditProfileDialog({
    required this.nameController,
    required this.ageController,
    required this.bioController,
    required this.locationController,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: ageController,
            decoration: InputDecoration(labelText: 'Age'),
          ),
          TextField(
            controller: bioController,
            decoration: InputDecoration(labelText: 'Bio'),
          ),
          TextField(
            controller: locationController,
            decoration: InputDecoration(labelText: 'Location'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onUpdatePressed();
            Navigator.pop(context); // Close the dialog after updating
          },
          child: Text('Update'),
        ),
      ],
    );
  }
}
