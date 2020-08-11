class DeliveryState {
  StateType type;
  String title;
  bool isDone;
  String notificationMsg;

  DeliveryState({this.type, this.title, this.isDone, this.notificationMsg});

  @override
  bool operator ==(dynamic other) {
    return other != null && other.type == type;
  }
}

enum StateType { ON_WAY, PICKED_UP, NEAR_DESTINATION, DELIVERED }
