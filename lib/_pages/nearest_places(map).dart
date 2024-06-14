//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:location/location.dart' as loc;
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../model/nearby response.dart' as nearby;
//
// class NearByPlacesScreen extends StatefulWidget {
//   static String routeName = 'fdkmnjf';
//
//   @override
//   State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
// }
//
// class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
//   String apiKey = "AIzaSyDbtJ1dV_G9nvMNo_Eh2PMRZgJR7tgUvm8";
//   String radius = "3000";
//
//   loc.Location location = loc.Location();
//   loc.LocationData? currentLocation;
//   nearby.NearbyPlacesResponse nearbyPlacesResponse = nearby.NearbyPlacesResponse();
//   late GoogleMapController mapController;
//   Set<Marker> markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }
//
//   Future<void> _getLocation() async {
//     try {
//       var locationData = await location.getLocation();
//       setState(() {
//         currentLocation = locationData;
//         if (currentLocation != null) {
//           getNearbyPlaces(currentLocation!.latitude!, currentLocation!.longitude!);
//         }
//       });
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   void getNearbyPlaces(double latitude, double longitude) async {
//     var url = Uri.parse(
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
//             latitude.toString() +
//             ',' +
//             longitude.toString() +
//             '&radius=' +
//             radius +
//             '&type=hospital' +
//             '&key=' +
//             apiKey);
//
//     var response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       print("Response: ${response.body}");
//       nearbyPlacesResponse = nearby.NearbyPlacesResponse.fromJson(jsonDecode(response.body));
//       if (nearbyPlacesResponse.results != null) {
//         print("Number of places found: ${nearbyPlacesResponse.results!.length}");
//         setMarkers();
//       }
//     } else {
//       print("Failed to load nearby places. Status code: ${response.statusCode}");
//       print("Response body: ${response.body}");
//     }
//
//     setState(() {});
//   }
//
//   void setMarkers() {
//     Set<Marker> newMarkers = {};
//     for (var result in nearbyPlacesResponse.results!) {
//       double distanceInMeters = Geolocator.distanceBetween(
//         currentLocation!.latitude!,
//         currentLocation!.longitude!,
//         result.geometry!.location!.lat!,
//         result.geometry!.location!.lng!,
//       );
//
//       newMarkers.add(
//         Marker(
//           markerId: MarkerId(result.placeId!),
//           position: LatLng(result.geometry!.location!.lat!, result.geometry!.location!.lng!),
//           infoWindow: InfoWindow(
//             title: result.name,
//             snippet: 'Distance: ${distanceInMeters.toStringAsFixed(2)} meters',
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (context) => Container(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text("Name: " + result.name!),
//                       Text("Distance: " + distanceInMeters.toStringAsFixed(2) + " meters"),
//                       Text(result.openingHours != null ? "Open" : "Closed"),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     }
//     setState(() {
//       markers = newMarkers;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nearby Hospitals'),
//         centerTitle: true,
//       ),
//       body: currentLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : GoogleMap(
//         onMapCreated: (controller) {
//           mapController = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//           zoom: 14,
//         ),
//         markers: markers,
//       ),
//     );
//   }
// }

// class _NearestPlacesState extends State<Nearest_places> {
//   GoogleMapController? _mapController;
//   Set<Marker> _markers = {};
//   Position? _currentPosition;
//   final String apiKey = 'AIzaSyDXl_L7a9MIlDg_bR3CEuBGLK0WBBE3pW0';
//   bool _loading = true;
//   String? _errorMessage;
//   TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   void _getCurrentLocation() async {
//     try {
//       _currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print('Current position: $_currentPosition');
//       setState(() {
//         _loading = false;
//       });
//       _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
//           LatLng(_currentPosition!.latitude, _currentPosition!.longitude), 14));
//       _getNearbyHospitals();
//     } catch (e) {
//       setState(() {
//         _loading = false;
//         _errorMessage = 'Error getting location: $e';
//       });
//       print('Error getting location: $e');
//     }
//   }
//
//   void _getNearbyHospitals({String? keyword}) async {
//     if (_currentPosition == null) return;
//
//     String url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=5000&type=hospital&key=$apiKey';
//
//     if (keyword != null && keyword.isNotEmpty) {
//       url =
//       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=5000&type=hospital&keyword=$keyword&key=$apiKey';
//     }
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       print('Response from Places API: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);
//         final results = json['results'];
//
//         setState(() {
//           _markers = results.map<Marker>((hospital) {
//             return Marker(
//               markerId: MarkerId(hospital['place_id']),
//               position: LatLng(hospital['geometry']['location']['lat'],
//                   hospital['geometry']['location']['lng']),
//               infoWindow: InfoWindow(
//                 title: hospital['name'],
//                 snippet: hospital['vicinity'],
//               ),
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                   BitmapDescriptor.hueYellow),
//             );
//           }).toSet();
//         });
//       } else {
//         setState(() {
//           _errorMessage =
//           'Error getting nearby hospitals: ${response.reasonPhrase}';
//         });
//         print('Error getting nearby hospitals: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error getting nearby hospitals: $e';
//       });
//       print('Error getting nearby hospitals: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Nearby Hospitals'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for nearest hospitals...',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     _getNearbyHospitals(keyword: _searchController.text);
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _loading
//                 ? Center(child: CircularProgressIndicator())
//                 : _errorMessage != null
//                 ? Center(child: Text(_errorMessage!))
//                 : _currentPosition == null
//                 ? Center(
//                 child: Text('Error: Current position is null'))
//                 : GoogleMap(
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(_currentPosition!.latitude,
//                     _currentPosition!.longitude),
//                 zoom: 14,
//               ),
//               markers: _markers,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

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
