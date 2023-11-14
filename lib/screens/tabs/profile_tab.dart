import 'package:flutter/material.dart';
import 'package:tripool_app/screens/sign_up.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {

    return SignupWidget();

  }
}
