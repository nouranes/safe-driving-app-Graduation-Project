import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../map/location.dart';

class Nearest_places extends StatefulWidget {
  static const String routeName = 'places';

  @override
  State<Nearest_places> createState() => _NearestPlacesState();
}

class _NearestPlacesState extends State<Nearest_places> {
  MyLocationManager locationManager = MyLocationManager();
  StreamSubscription<LocationData>? streamSubscription;
  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(30.4589107, 31.2296214),
    zoom: 15,
  );
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    trackUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Places',
            style: TextStyle(color: Colors.black, fontSize: 22)),
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        polylines: polylines,
        onMapCreated: (controller) {
          mapController = controller;
        },
        onTap: (LatLng position) {
          setState(() {
            polylineCoordinates.add(position);
            _updatePolylines();
          });
        },
      ),
    );
  }

  void _updatePolylines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId('route1'),
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() {
      polylines.clear();
      polylines.add(polyline);
    });
  }

  void trackUserLocation() async {
    bool serviceEnabled = await locationManager.isServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationManager.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    bool permissionGranted = await locationManager.isPermissionGranted();
    if (!permissionGranted) {
      permissionGranted = await locationManager.requestPermission();
      if (!permissionGranted) {
        return;
      }
    }

    var locationData = await locationManager.getUserLocation();
    if (locationData != null) {
      LatLng currentLocation = LatLng(
          locationData.latitude!, locationData.longitude!);
      polylineCoordinates.add(
          currentLocation); // Adding the initial location to polyline

      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation));

      Marker userMarker = Marker(
        markerId: MarkerId('user'),
        position: currentLocation,
      );
      setState(() {
        markers.add(userMarker);
        initialCameraPosition =
            CameraPosition(target: currentLocation, zoom: 15);
      });
    }

    locationManager.updateUserLocation().listen((newLocation) {
      LatLng updatedLocation = LatLng(
          newLocation.latitude!, newLocation.longitude!);
      Marker userMarker = Marker(
        markerId: MarkerId('user'),
        position: updatedLocation,
      );
      setState(() {
        markers.add(userMarker);
      });
    });
  }
}


// class MyLocationManager {
//   Location myLocation = Location();
//
//   Future<bool> isPermissionGranted() async {
//     var permissionStatus = await myLocation.hasPermission();
//     return permissionStatus == PermissionStatus.granted;
//   }
//
//   Future<bool> requestPermission() async {
//     var permissionStatus = await myLocation.requestPermission();
//     return permissionStatus == PermissionStatus.granted;
//   }
//
//   Future<bool> isServiceEnabled() async {
//     var serviceEnabled = await myLocation.serviceEnabled();
//     return serviceEnabled;
//   }
//
//   Future<bool> requestService() async {
//     var serviceEnabled = await myLocation.serviceEnabled();
//     return serviceEnabled;
//   }
//
//   Future<LocationData?> getUserLocation() async {
//     var permissionStatus = await requestPermission();
//     var serviceEnabled = await requestService();
//     if (!permissionStatus || !serviceEnabled) {
//       return null;
//     }
//     return myLocation.getLocation();
//   }
//
//   Stream<LocationData> updateUserLocation() {
//     return myLocation.onLocationChanged;
//   }
// }

/*
AIzaSyB0FJu75kvRtonN6mLBQlBz8CnP01mbel0
 */
// body: Column(
//   children: [
//     GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, NearestHospital.routeName);
//       },
//       child: Info_Card(
//         text: "Nearest Hospital",
//         icon: Icons.location_on_rounded,
//       ),
//     ),
//     //_______________________________________
//     GestureDetector(
//       onTap: () {
//         Navigator.pushNamed(context, NearestGasoline.routeName);
//       },
//       child: Info_Card(
//         text: "Nearest Gasoline",
//         icon: Icons.location_on_rounded,
//       ),
//     )
//   ],
// )
