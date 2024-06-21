import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/_pages/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc; // Alias the location package
import 'package:uuid/uuid.dart';

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
  loc.Location location = loc.Location();
  LatLng? currentLocation;
  LatLng? startLocation;
  LatLng? endLocation;
  StreamSubscription<loc.LocationData>? locationSubscription;
  Marker? purpleMarker;
  String apiKey = "AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8";
  String radius = "3000";
  TextEditingController destinationController = TextEditingController();
  String distanceText = '';
  String durationText = '';
  List<String> placeSuggestions = [];
  Uuid uuid = Uuid();
  String sessionToken = '';

  // Variables to store addresses without coordinates
  String? startAddress;
  String? endAddress;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    destinationController.addListener(() {
      onChanged();
    });
  }

  void onChanged() {
    if (sessionToken == '') {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestion(destinationController.text);
  }

  void getSuggestion(String input) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      var predictions = json.decode(response.body)['predictions'] as List<dynamic>;
      setState(() {
        placeSuggestions = predictions.map((prediction) => prediction['description'] as String).toList();
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void _addMarkerAndPolyline(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId('destination_${position.latitude}_${position.longitude}'),
        position: position,
        onTap: () => _drawPolyline(position),
      ));
      _drawPolyline(position);
    });
  }

  void _drawPolyline(LatLng destination) async {
    try {
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
            polylineId: PolylineId('polyline_${destination.latitude}_${destination.longitude}'),
            color: Colors.blue,
            points: polylineCoordinates,
          ));
        });

        _calculateDistanceAndDuration(destination);

        // Update start and end locations
        startLocation = currentLocation;
        endLocation = destination;

        // Get the address of the destination
        List<Placemark> placemarks = await placemarkFromCoordinates(destination.latitude, destination.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          endAddress = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        }

        // Remove text field after location selection
        setState(() {
          destinationController.clear();
          placeSuggestions.clear();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to draw polyline: $e')),
      );
    }
  }

  void _calculateDistanceAndDuration(LatLng destination) async {
    try {
      var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=' +
            currentLocation!.latitude.toString() +
            ',' +
            currentLocation!.longitude.toString() +
            '&destinations=' +
            destination.latitude.toString() +
            ',' +
            destination.longitude.toString() +
            '&key=' +
            apiKey,
      );

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var elements = data['rows'][0]['elements'][0];
        setState(() {
          distanceText = elements['distance']['text'];
          durationText = elements['duration']['text'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to calculate distance and duration: $e')),
      );
    }
  }

  void _getCurrentLocation() async {
    try {
      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return;
        }
      }

      locationSubscription = location.onLocationChanged.listen((loc.LocationData currentLocationData) {
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
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              );
            } else {
              purpleMarker = purpleMarker!.copyWith(
                positionParam: currentLocation!,
              );
            }

            markers.removeWhere((marker) => marker.markerId == MarkerId('purpleMarker'));
            markers.add(purpleMarker!);
          });

          mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location: $e')),
      );
    }
  }

  void _getNearbyPlaces(String placeType) async {
    try {
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
            apiKey,
      );

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
              onTap: () async {
                List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
                if (placemarks.isNotEmpty) {
                  Placemark place = placemarks[0];
                  String address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                }
              },
            ),
          );
        });

        setState(() {
          markers.clear();
          markers.addAll(placeMarkers);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get nearby places: $e')),
      );
    }
  }

  String _calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude  );
    double distanceInKm = distanceInMeters / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  void _showRoute() async {
    try {
      String destination = destinationController.text;
      List<Location> locations = await locationFromAddress(destination);

      if (locations.isNotEmpty) {
        LatLng destinationLatLng = LatLng(locations[0].latitude, locations[0].longitude);
        _addMarkerAndPolyline(destinationLatLng);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to show route: $e')),
      );
    }
  }
void _printStartAndEndPoints() async {
  if (startLocation != null && endLocation != null) {
    // Get addresses for start and end locations
    List<Placemark> startPlacemark = await placemarkFromCoordinates(startLocation!.latitude, startLocation!.longitude);
    List<Placemark> endPlacemark = await placemarkFromCoordinates(endLocation!.latitude, endLocation!.longitude);

    if (startPlacemark.isNotEmpty && endPlacemark.isNotEmpty) {
      startAddress = "${startPlacemark[0].name}, ${startPlacemark[0].locality}, ${startPlacemark[0].administrativeArea}, ${startPlacemark[0].country}";
      endAddress = "${endPlacemark[0].name}, ${endPlacemark[0].locality}, ${endPlacemark[0].administrativeArea}, ${endPlacemark[0].country}";

      // Create a Journey object
      Journey journey = Journey(
        startDirection: startAddress!,
        endDirection: endAddress!,
        duration: durationText,
        distance: distanceText,
      );

      // Update journey history in Firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'journeyHistory': FieldValue.arrayUnion([journey.toJson()])
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Journey history updated successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update journey history: $error')),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get addresses')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No start or end location available')),
    );
  }
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
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _printStartAndEndPoints,
          ),
        ],
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
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
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
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      hintText: 'Find places',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: destinationController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  destinationController.clear();
                                  placeSuggestions.clear();
                                });
                              },
                            )
                          : null,
                    ),
                    onSubmitted: (value) {
                      _showRoute();
                    },
                  ),
                 if (placeSuggestions.isNotEmpty)
  Container(
    color: Colors.white,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: placeSuggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(placeSuggestions[index]),
          onTap: () async {
            String selectedSuggestion = placeSuggestions[index];
            List<Location> locations = await locationFromAddress(selectedSuggestion);
            if (locations.isNotEmpty) {
              LatLng selectedLatLng = LatLng(locations[0].latitude, locations[0].longitude);
              _addMarkerAndPolyline(selectedLatLng);
            }
            setState(() {
              destinationController.text = selectedSuggestion;
              placeSuggestions.clear();
            });
          },
        );
      },
    ),
  ),

                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => _getNearbyPlaces('hospital'),
                        child: Text(
                          "Hospitals",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _getNearbyPlaces('restaurant'),
                        child: Text(
                          "Restaurants",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _getNearbyPlaces('gas_station'),
                        child: Text(
                          "Gas Stations",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (distanceText.isNotEmpty && durationText.isNotEmpty)
            Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Distance: $distanceText',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Duration: $durationText',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
