import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityWidget extends StatefulWidget {
  final Widget child;

  ConnectivityWidget({@required this.child});

  @override
  State<StatefulWidget> createState() {
    return _ConnectivityState();
  }
}

class _ConnectivityState extends State<ConnectivityWidget> {
  bool _isOnline = false;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isOnline = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        connectivityBanner(),
      ],
    );
  }

  connectivityBanner() {
    return _isOnline
        ? Container()
        : Container(
            width: double.infinity,
            height: 65,
            color: Colors.grey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(
                  "No Internet Connection",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ));
  }

  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }
}
