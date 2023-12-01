import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tripool_app/screens/tabs/create_tab.dart';
import 'package:tripool_app/screens/tabs/explore_tab.dart';
import 'package:tripool_app/screens/tabs/profile_tab.dart';
import 'package:tripool_app/screens/tabs/schedule_tab.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late PersistentTabController _controller;
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
    _hideNavBar = false;
  }

  List<Widget> _buildTabs() {
    return [
      ScheduleTab(),
      // HomeTab(),
      CreateActivityTab(),
      ExploreTab(),
      ProfileTab(),
    ];
  }
  //  Stream<bool> hasPendingRequests() {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   return FirebaseFirestore.instance
  //     .collection('Activity')
  //     .where('Creator', isEqualTo: currentUser?.uid)
  //     .snapshots()
  //     .map((snapshot) => 
  //       snapshot.docs.any((doc) => (doc.data()['Requests'] as List).isNotEmpty));
  // }

  // Stream to check for pending requests ,left activity notifications, accpted request and rejected request
  Stream<bool> hasNotifications() {
  final currentUser = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
    .collection('Activity')
    .snapshots()
    .map((snapshot) => snapshot.docs.any((doc) {
      final data = doc.data();
      final notifRequest = data['Notif_Request'] as List<dynamic>? ?? [];
      final notifLeftActivity = data['Notif_LeftActivity'] as List<dynamic>? ?? [];
      final notifAcceptedRequest = data['Notif_AcceptedRequest'] as List<dynamic>? ?? [];
      final notifRemoveMembers = data['Notif_RemovedMembers'] as List<dynamic>? ?? [];
      bool isCurrentUserInvolved = notifAcceptedRequest.contains(currentUser?.uid) || notifRemoveMembers.contains(currentUser?.uid);
      return isCurrentUserInvolved || (currentUser?.uid == data['Creator'] && (notifRequest.isNotEmpty || notifLeftActivity.isNotEmpty));
    }));
}


 List<PersistentBottomNavBarItem> _navBarItems(bool showIndicator) {
    // find if the user's created group has request

    return [
      PersistentBottomNavBarItem(
        icon: showIndicator
            ? Stack(
                children: [
                  const Icon(Icons.calendar_month),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
                ],
              )
            : const Icon(Icons.calendar_month),
        title: ("Schedule"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.home),
      //   title: ("Home"),
      //   activeColorPrimary: Theme.of(context).colorScheme.primary,
      //   // inactiveColorPrimary: Colors.grey,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.create_new_folder),
        title: ("Create"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        // inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.explore),
        title: ("Explore"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        // inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Theme.of(context).colorScheme.primary,
        // inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: StreamBuilder<bool>(
        stream:hasNotifications(),
        builder: (context, snapshot) {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: _buildTabs(),
            items: _navBarItems(snapshot.data ?? false),
            confineInSafeArea: true,
            // ... other properties
            handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1,
          );
        }
      ),
    );
      
  }
}
