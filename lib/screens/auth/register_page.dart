import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import 'package:tripool_app/screens/auth/auth_page.dart';
import 'package:tripool_app/screens/auth/signUpSuccess_page.dart';
import "package:tripool_app/screens/bottom_bar_screen.dart";

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    // Check if any field is empty
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _confirmpasswordController.text.trim().isNotEmpty &&
        _nameController.text.trim().isNotEmpty &&
        _ageController.text.trim().isNotEmpty &&
        _bioController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty;
  }

  Future signUp() async {
  if (!_validateFields()) {
    _showDialog('Please fill out all fields');
    return;
  }

  if (!passwordConfirmed()) {
    _showDialog('Passwords do not match');
    return;
  }

  try {
    // User creation process
    UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Add user details
    await addUserDetails(
      cred.user!.uid,
      _emailController.text.trim(),
      _nameController.text.trim(),
      int.parse(_ageController.text.trim()),
      _bioController.text.trim(),
      _locationController.text.trim(),
    );

    // Navigate to success page
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpSuccessPage(
              goToLoginPage: () {
                Navigator.pop(context); // Pop SignUpSuccessPage
                // Optionally, reset AuthPage to show login page by navigating to it
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomBarScreen()),
                );
              },
            ),
          ),
        );

  } on FirebaseAuthException catch (e) {
    // If Firebase throws an exception, show it in a dialog
    _showDialog('Failed to sign up: ${e.message}');
  } catch (e) {
    // For any other exceptions
    _showDialog('An unexpected error occurred');
  }
}


  

  // pop up window
  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future addUserDetails(String id, String email, String name, int age,
      String bio, String location) async {
    await FirebaseFirestore.instance.collection('Users').doc(id).set({
      'Name': name,
      'email': email,
      'Location': location,
      'Description': bio,
      'Age': age,
      'Rating': 0, // Assuming a default rating
      'Created_Activities': [], // Empty array as default
      'Joined_Activities': [], // Empty array as default
      'Requested_Activities': [] // Empty array as default
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.where_to_vote_outlined,
                    size: 100,
                  ),
                  SizedBox(height: 75),
                  Text(
                    'Register below with your details!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 50),
                  // Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Name *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Age
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _ageController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Age *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // email Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
        
                  // Location
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Location *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
        
                  // Bio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _bioController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Bio *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
        
                  // password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // confirm password textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _confirmpasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Confrm Password *',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: signUp,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I am a Member!',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width:10),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          'Login Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
