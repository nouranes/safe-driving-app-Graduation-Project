import 'package:final_project/map/nearest_gasoline.dart';
import 'package:final_project/map/nearest_hospital.dart';
import 'package:final_project/widgets/infocard.dart';
import 'package:flutter/material.dart';

class Nearest_places extends StatelessWidget {
  static const String routeName = 'places';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nearest Places',
              style: TextStyle(color: Colors.black, fontSize: 22)),
        ),
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NearestHospital.routeName);
              },
              child: Info_Card(
                text: "Nearest Hospital",
                icon: Icons.location_on_rounded,
              ),
            ),
            //_______________________________________
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NearestGasoline.routeName);
              },
              child: Info_Card(
                text: "Nearest Gasoline",
                icon: Icons.location_on_rounded,
              ),
            )
          ],
        ));
  }
}
