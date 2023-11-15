// import 'package:flutter/material.dart';
// import 'package:tripool_app/screens/activity_details.dart';

// class ExploreTab extends StatefulWidget {
//   const ExploreTab({super.key});

//   @override
//   State<ExploreTab> createState() => _ExploreTabState();
// }

// class _ExploreTabState extends State<ExploreTab> {
//   @override
//   Widget build(BuildContext context) {
//     // final currUser = FirebaseAuth.instance.currentUser!;
//     // return StreamBuilder<QuerySnapshot>(
//     //     stream: FirebaseFirestore.instance.collection('sigs').snapshots(),
//     //     builder: (_, snapshot) {
//     //       if (snapshot.data == null ||
//     //           snapshot.connectionState == ConnectionState.waiting) {
//     //         return LoadingWidget();
//     //       }

//           // final sigDocs = snapshot.data!.docs;
//           // return sigDocs.length == 0
//            //   ? Center(child: Text('Sigs Coming Up Soon ... Stay Tuned'))
//            //   : ListView.builder(
//                   // itemCount: sigDocs.length,
//                   return ListView.builder(
//                   itemBuilder: (_, index) {
//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => DetailsPage(),
//                             ),
//                           );
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Card(
//                           shadowColor: Theme.of(context).primaryColor,
//                           elevation: 8,
//                           clipBehavior: Clip.antiAlias,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Theme.of(context).primaryColor,
//                                   Theme.of(context).secondaryHeaderColor
//                                 ],
//                                 begin: Alignment.topRight,
//                                 end: Alignment.bottomLeft,
//                               ),
//                             ),
//                             padding: EdgeInsets.all(16),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Title ',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w800),
//                                     ),
//                                     Text(
//                                       // sigDocs[index]['sigTitle'],
//                                       "Title",
//                                       style: TextStyle(fontSize: 18),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Text(
//                                     'Description ',
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w800),
//                                   ),
//                                 ),
//                                 Text('Description',
//                                     overflow: TextOverflow.clip),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Host  ',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w800),
//                                     ),
//                                     Text(
//                                       'Host Name',
//                                       style: TextStyle(fontSize: 18),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Date',
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w800),
//                                     ),
//                                     Text(
//                                       'Category',
//                                       style: TextStyle(fontSize: 17),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   });
//         }
//   }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tripool_app/backgrounds/explore_tab_background.dart';
import 'package:tripool_app/model/category.dart';
import 'package:tripool_app/model/event.dart';
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
              minimum: EdgeInsets.fromLTRB(10, 40, 10, 10),
              child: SingleChildScrollView(
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
                        builder: (context, appState, _) =>
                            SingleChildScrollView(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) => Column(
                          children: <Widget>[
                            for (final event in events.where((e) => e
                                .categoryIds
                                .contains(appState.selectedCategoryId)))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                          activityId: 'cLAurMltckBHzb3WslhZ'),
                                    ),
                                  );
                                },
                                child: EventWidget(
                                  event: event,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
