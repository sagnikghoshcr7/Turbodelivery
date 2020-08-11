import 'package:flutter/material.dart';

import 'timeline_widget.dart';

class TrackingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackingWidgetState();
  }
}

class _TrackingWidgetState extends State<TrackingWidget> {
  Widget trackingView() {
    return Positioned.fill(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 380,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      height: 300,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(children: [
                      Card(
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              ExactAssetImage('assets/images/Sagnik.jpg'),
                          minRadius: 70,
                          maxRadius: 70,
                        ),
                        elevation: 30,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sagnik Ghosh',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),

                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: TimeLineWidget())
                    ]))
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return trackingView();
  }
}
