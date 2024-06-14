import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = LatLng(37.77483, -122.41942);
  final List<LatLng> polylineCoordinates = [];
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  Location location = Location();
  LatLng? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;
  Marker? purpleMarker;
  String apiKey = "AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8";
  String radius = "3000";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _addMarkerAndPolyline(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId:
            MarkerId('destination_${position.latitude}_${position.longitude}'),
        position: position,
      ));
      _drawPolyline(position);
    });
  }

  void _drawPolyline(LatLng destination) async {
    if (currentLocation == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        polylines.clear();
        polylines.add(Polyline(
          polylineId: PolylineId(
              'polyline_${destination.latitude}_${destination.longitude}'),
          color: Colors.blue,
          points: polylineCoordinates,
        ));
      });
    }
  }

  void _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocationData) {
      if (mounted) {
        setState(() {
          currentLocation = LatLng(
            currentLocationData.latitude!,
            currentLocationData.longitude!,
          );

          if (purpleMarker == null) {
            purpleMarker = Marker(
              markerId: MarkerId('purpleMarker'),
              position: currentLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet),
            );
          } else {
            purpleMarker = purpleMarker!.copyWith(
              positionParam: currentLocation!,
            );
          }

          markers.removeWhere(
              (marker) => marker.markerId == MarkerId('purpleMarker'));
          markers.add(purpleMarker!);
        });

        mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
      }
    });
  }

  void _getNearbyPlaces(String placeType) async {
    if (currentLocation == null) return;

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            currentLocation!.latitude.toString() +
            ',' +
            currentLocation!.longitude.toString() +
            '&radius=' +
            radius +
            '&type=' +
            placeType +
            '&key=' +
            apiKey);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var results = data['results'] as List;

      Set<Marker> placeMarkers = {};
      results.forEach((place) {
        var location = place['geometry']['location'];
        LatLng position = LatLng(location['lat'], location['lng']);

        placeMarkers.add(
          Marker(
            markerId: MarkerId(place['place_id']),
            position: position,
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['vicinity'] +
                  ' - ' +
                  _calculateDistance(currentLocation!, position) +
                  ' km away',
            ),
          ),
        );
      });

      setState(() {
        markers.clear();
        markers.addAll(placeMarkers);
      });
    }
  }

  String _calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
    return (distanceInMeters / 1000).toStringAsFixed(2);
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Places'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12.0,
            ),
            markers: {
              if (currentLocation != null)
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: currentLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                ),
              ...markers,
            },
            polylines: polylines,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
            onTap: _addMarkerAndPolyline,
          ),
          Positioned(
            top: 1,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _getNearbyPlaces('hospital'),
                      child: Text("Hospitals"),
                    ),
                    ElevatedButton(
                      onPressed: () => _getNearbyPlaces('restaurant'),
                      child: Text("Restaurants"),
                    ),
                    ElevatedButton(
                      onPressed: () => _getNearbyPlaces('gas_station'),
                      child: Text("Gas Stations"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
