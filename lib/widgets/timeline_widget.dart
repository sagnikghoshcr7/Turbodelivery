import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabbar_challenge/models/delivery_listview_model.dart';

class TimeLineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimeLineState();
  }
}

class _TimeLineState extends State<TimeLineWidget> {
  @override
  void initState() {
    super.initState();
    Provider.of<DeliveryStateListViewModel>(context, listen: false)
        .getAllStates();
  }

  @override
  Widget build(BuildContext context) {
    return _timeLine(
        Provider.of<DeliveryStateListViewModel>(context).deliveryStates);
  }

  Widget _timeLine(List<DeliveryStateViewModel> deliveryStates) {
    return Container(
      child: Column(
        children: _timeLineItems(deliveryStates),
      ),
    );
  }

  Widget _timelineRow({String title, bool isDone, bool isFirst}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 3,
                height: 30,
                decoration: new BoxDecoration(
                  color: isFirst
                      ? Colors.transparent
                      : (isDone ? Colors.black : Colors.white),
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: new BoxDecoration(
                  color: isDone ? Colors.black : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${title}',
                  style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      color: isDone ? Colors.black : Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  _timeLineItems(List<DeliveryStateViewModel> deliveryStates) {
    List<Widget> items = List();
    for (int i = 0; i < deliveryStates.length; i++) {
      items.add(_timelineRow(
          title: deliveryStates[i].state.title,
          isDone: deliveryStates[i].state.isDone,
          isFirst: i == 0));
    }

    return items;
  }
}
