
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

class ExploreTab extends StatelessWidget {
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
              minimum: EdgeInsets.fromLTRB(10, 40,10, 10),
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
                          children: <Widget>[for (final category in categories) CategoryWidget(category: category)],
                        ),
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
