import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tripool_app/backgrounds/explore_tab_background.dart';
import 'package:tripool_app/model/category.dart';
import 'package:tripool_app/model/event.dart';
import 'package:tripool_app/screens/explore_activities_list.dart';
import 'package:tripool_app/styleguide.dart';
import 'package:tripool_app/screens/activity_details.dart';

import '../../app_state.dart';
import 'package:tripool_app/widgets/category_widget.dart';
import 'package:tripool_app/widgets/event_widget.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
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
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "Find Activities",
                      style: fadedTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      "Explore",
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
                            for (final category in categories)
                              CategoryWidget(category: category)
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
                  ActivityList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
