import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sabbar_challenge/states/delivery_state.dart';
import 'package:sabbar_challenge/models/delivery_listview_model.dart';

import '../driver_simulator.dart';

class MapWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapWidgetState();
  }
}

const double CAMERA_ZOOM = 16;
const LatLng PICK_UP_LOCATION = LatLng(29.896248, 31.058142);
const LatLng DROP_OFF_LOCATION = LatLng(29.892662, 31.080896);
const GOOGLE_API_KEY = "AIzaSyBIlHyOwYpbtJVJvaXkSmpWZEKwR8pxqVA";

class _MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor pickUpIcon, dropOffIcon, driverIcon;
  LatLng driverLocation, pickupLocation, dropOffLocation;
  CameraPosition initialCameraPosition =
      CameraPosition(zoom: CAMERA_ZOOM, target: PICK_UP_LOCATION);

  var _firebaseRef = FirebaseDatabase().reference().child('driver_location');

  DriverSimulator _driverSimulator;

  @override
  void initState() {
    super.initState();

    _driverSimulator = DriverSimulator(_firebaseRef);

    setInitialLocation();

    _firebaseRef.onChildChanged.listen((event) {
      _onLocationChanged(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mapViw();
  }

  void updatePinOnMap(LatLng currentLocation) async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      target: currentLocation,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    setState(() {
      var pinPosition = currentLocation;

      _markers.removeWhere((m) => m.markerId.value == 'driverPin');
      _markers.add(Marker(
          markerId: MarkerId('driverPin'),
          position: pinPosition,
          icon: driverIcon));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future setCustomMapIcons() async {
    await getBytesFromAsset('assets/images/source_map_marker.png', 150)
        .then((value) {
      setState(() {
        pickUpIcon = BitmapDescriptor.fromBytes(value);
      });
    });

    await getBytesFromAsset('assets/images/driving_pin.png', 100)
        .then((value) {
      setState(() {
        driverIcon = BitmapDescriptor.fromBytes(value);
      });
    });

    await getBytesFromAsset('assets/images/destination_map_marker.png', 80)
        .then((value) {
      setState(() {
        dropOffIcon = BitmapDescriptor.fromBytes(value);
      });
    });
  }

  void setInitialLocation() {
    pickupLocation = PICK_UP_LOCATION;

    driverLocation = _driverSimulator.driverRoute[0];

    dropOffLocation = DROP_OFF_LOCATION;
  }

  void showPinsOnMap() {
    var sourcePin = LatLng(pickupLocation.latitude, pickupLocation.longitude);
    var destPosition =
        LatLng(dropOffLocation.latitude, dropOffLocation.longitude);
    var driverPosition =
        LatLng(driverLocation.latitude, driverLocation.longitude);

    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: sourcePin,
        icon: pickUpIcon));

    _markers.add(Marker(
        markerId: MarkerId('driverPin'),
        position: driverPosition,
        icon: driverIcon));

    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: dropOffIcon));
  }

  void _onLocationChanged(Event event) {
    var driverLocation = LatLng(
        event.snapshot.value["latitude"], event.snapshot.value["longitude"]);
    _checkDeliveryStatus(driverLocation);
    updatePinOnMap(driverLocation);
  }

  void _checkDeliveryStatus(LatLng driverLocation) {
    String notificationMsg = "";
    if (Provider.of<DeliveryStateListViewModel>(context, listen: false)
            .currentState ==
        null) {
      Geolocator()
          .distanceBetween(pickupLocation.latitude, pickupLocation.longitude,
              driverLocation.latitude, driverLocation.longitude)
          .then((value) {
        if (value / 1000 <= 5) {
          Provider.of<DeliveryStateListViewModel>(context, listen: false)
              .setState(DeliveryState(type: StateType.ON_WAY));
        }
      });
    } else {
      switch (Provider.of<DeliveryStateListViewModel>(context, listen: false)
          .currentState
          .stateType) {
        case StateType.ON_WAY:
          Geolocator()
              .distanceBetween(
                  pickupLocation.latitude,
                  pickupLocation.longitude,
                  driverLocation.latitude,
                  driverLocation.longitude)
              .then((value) {
            if (value / 1000 <= 0.1) {
              Provider.of<DeliveryStateListViewModel>(context, listen: false)
                  .setState(DeliveryState(type: StateType.PICKED_UP));
            }
          });
          break;
        case StateType.PICKED_UP:
          Geolocator()
              .distanceBetween(
                  driverLocation.latitude,
                  driverLocation.longitude,
                  dropOffLocation.latitude,
                  dropOffLocation.longitude)
              .then((value) {
            if (value / 1000 <= 5) {
              Provider.of<DeliveryStateListViewModel>(context, listen: false)
                  .setState(DeliveryState(type: StateType.NEAR_DESTINATION));
            }
          });
          break;
        case StateType.NEAR_DESTINATION:
          Geolocator()
              .distanceBetween(
                  dropOffLocation.latitude,
                  dropOffLocation.longitude,
                  driverLocation.latitude,
                  driverLocation.longitude)
              .then((value) {
            if (value / 1000 <= 0.1) {
              Provider.of<DeliveryStateListViewModel>(context, listen: false)
                  .setState(DeliveryState(type: StateType.DELIVERED));
            }
          });
          break;
        case StateType.DELIVERED:
          break;
      }
    }
  }

  _mapViw() {
    return Padding(
      padding: EdgeInsets.only(bottom: 230),
      child: GoogleMap(
        zoomGesturesEnabled: true,
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setCustomMapIcons().then((value) {
            showPinsOnMap();
            DriverSimulator(_firebaseRef).updateDriverLocation();
          });
        },
      ),
    );
  }
}
