// import 'package:flutter/material.dart';

// class ScheduleTab extends StatefulWidget {
//   const ScheduleTab({super.key});

//   @override
//   State<ScheduleTab> createState() => _ScheduleTabState();
// }

// class _ScheduleTabState extends State<ScheduleTab> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tripool_app/backgrounds/explore_tab_background.dart';
import 'package:tripool_app/model/category.dart';
import 'package:tripool_app/model/event.dart';
import 'package:tripool_app/model/my_schedule_category.dart';
import 'package:tripool_app/screens/myschedule_list.dart';
import 'package:tripool_app/styleguide.dart';
import 'package:tripool_app/screens/activity_details.dart';

import '../../app_state.dart';
import 'package:tripool_app/widgets/my_category_widget.dart';
import 'package:tripool_app/widgets/event_widget.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: Stack(
          children: <Widget>[
            ExploreTabBackground(
              screenHeight: MediaQuery.of(context).size.height,
            ),
            SafeArea(
              minimum: EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "My Activities",
                      style: fadedTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Categories",
                      style: whiteHeadingTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Consumer<AppState>(
                      builder: (context, appState, _) => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (final category in mycategories)
                              myCategoryWidget(category: category)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Consumer<AppState>(
                    builder: (context, appState, _) => TextField(
                      controller: searchController,
                      onChanged: appState.updateSearch,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: 'Enter a search term',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  MyActivityList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
