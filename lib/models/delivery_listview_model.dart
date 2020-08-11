import 'package:flutter/cupertino.dart';
import 'package:sabbar_challenge/states/delivery_state.dart';

import '../utils/push_notification_util.dart';

class DeliveryStateListViewModel extends ChangeNotifier {
  List<DeliveryStateViewModel> deliveryStates;
  DeliveryStateViewModel currentState;

  Future<void> getAllStates() async {
    List<DeliveryState> states = [
      DeliveryState(
          type: StateType.ON_WAY,
          title: "On the way",
          isDone: false,
          notificationMsg: "Driver is on his way to pick up your package"),
      DeliveryState(
          type: StateType.PICKED_UP,
          title: "Picked up delivery",
          isDone: false,
          notificationMsg: "Driver has picked up your package"),
      DeliveryState(
          type: StateType.NEAR_DESTINATION,
          title: "Near Delivery Destination",
          isDone: false,
          notificationMsg: "Driver is near delivery destination"),
      DeliveryState(
          type: StateType.DELIVERED,
          title: "Deliverd Package",
          isDone: false,
          notificationMsg: "Your package has beed delivered!"),
    ];

    this.deliveryStates =
        states.map((state) => DeliveryStateViewModel(state: state)).toList();

    notifyListeners();
  }

  void setState(DeliveryState deliveryState) {
    currentState = deliveryStates[
        deliveryStates.indexOf(DeliveryStateViewModel(state: deliveryState))];
    currentState.setDone(true);
    PushNotificationUtil().showNotification(text: currentState.notificationTxt);
    notifyListeners();
  }
}

class DeliveryStateViewModel {
  DeliveryState state;

  DeliveryStateViewModel({this.state});

  String get title {
    return state.title;
  }

  String get notificationTxt {
    return state.notificationMsg;
  }

  StateType get stateType {
    return state.type;
  }

  bool get isDone {
    return state.isDone;
  }

  void setDone(bool isDone) {
    state.isDone = isDone;
  }

  @override
  bool operator ==(dynamic other) {
    return other.state == state;
  }
}
