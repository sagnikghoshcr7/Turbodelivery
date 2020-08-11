import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabbar_challenge/models/delivery_listview_model.dart';
import 'package:sabbar_challenge/states/delivery_state.dart';
import 'package:sabbar_challenge/widgets/connectivity_widget.dart';
import 'package:sabbar_challenge/widgets/map_widget.dart';
import 'package:sabbar_challenge/widgets/rating_widget.dart';
import 'package:sabbar_challenge/widgets/tracking_widget.dart';

class DeliveryTrackerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeliveryTrackerState();
  }
}

class _DeliveryTrackerState extends State<DeliveryTrackerPage> {
  @override
  Widget build(BuildContext _context) {
    return new Scaffold(
      body: ConnectivityWidget(
          child: Stack(children: <Widget>[
            MapWidget(),
            Provider
                .of<DeliveryStateListViewModel>(context, listen: true)
                .currentState !=
                null &&
                Provider
                    .of<DeliveryStateListViewModel>(context,
                    listen: false)
                    .currentState
                    .stateType ==
                    StateType.DELIVERED
                ? RatingWidget()
                : TrackingWidget(),
          ])
      ),
    );
  }
}
