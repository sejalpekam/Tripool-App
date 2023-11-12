import 'package:flutter/material.dart';
import 'package:tripool_app/screens/activity_details.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  @override
  Widget build(BuildContext context) {
    // final currUser = FirebaseAuth.instance.currentUser!;
    // return StreamBuilder<QuerySnapshot>(
    //     stream: FirebaseFirestore.instance.collection('sigs').snapshots(),
    //     builder: (_, snapshot) {
    //       if (snapshot.data == null ||
    //           snapshot.connectionState == ConnectionState.waiting) {
    //         return LoadingWidget();
    //       }

          // final sigDocs = snapshot.data!.docs;
          // return sigDocs.length == 0
           //   ? Center(child: Text('Sigs Coming Up Soon ... Stay Tuned'))
           //   : ListView.builder(
                  // itemCount: sigDocs.length,
                  return ListView.builder(
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(),
                            ),
                          );
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          shadowColor: Theme.of(context).primaryColor,
                          elevation: 8,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).secondaryHeaderColor
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Title ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      // sigDocs[index]['sigTitle'],
                                      "Title",
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Description ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                Text('Description',
                                    overflow: TextOverflow.clip),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Host  ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'Host Name',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'Category',
                                      style: TextStyle(fontSize: 17),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        }
  }

