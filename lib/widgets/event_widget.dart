import 'package:flutter/material.dart';
import 'package:tripool_app/styleguide.dart';

import '../../model/event.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final bool hasPendingRequests;

  const EventWidget({Key? key, required this.event, this.hasPendingRequests = false}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Stack(
    children: [
     Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          event.title,
                          style: eventTitleTextStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                event.location,
                                style: eventLocationTextStyle,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                event.hostname,
                                style: eventLocationTextStyle.copyWith(fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          event.startdate,
                          textAlign: TextAlign.right,
                          style: eventLocationTextStyle.copyWith(fontWeight: FontWeight.w700),
                          
                        ),
                        SizedBox(height: 10,),
                        Text(
                          event.starttime,
                          textAlign: TextAlign.right,
                          style: eventLocationTextStyle.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
            ),
          ],
        ),
      ),
    ),
    // red dot
      if (hasPendingRequests)
        Positioned(
          right: 5,
          top: 20,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
    ],
  );
    
  }
}
