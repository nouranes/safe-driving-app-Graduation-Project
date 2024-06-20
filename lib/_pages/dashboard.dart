import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowResult extends StatefulWidget {
  static String routeName = "jdcn";

  @override
  _ShowResultState createState() => _ShowResultState();
}

class _ShowResultState extends State<ShowResult> {
  double drowsyPercentage = 0.0;
  double seatbeltPercentage = 0.0;
  double distractedPercentage = 0.0;
  bool isLoading = true; // Initially set to true to show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchPercentages();
  }

  Future<void> _fetchPercentages() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (userDoc.exists) {
          setState(() {
            drowsyPercentage = (userDoc['drowsyPercentage'] as num?)?.toDouble() ?? 0.0;
            seatbeltPercentage = (userDoc['noSeatBeltPercentage'] as num?)?.toDouble() ?? 0.0;
            distractedPercentage = (userDoc['distractedPercentage'] as num?)?.toDouble() ?? 0.0;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        // Handle user not logged in
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching percentages: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Drowsy": drowsyPercentage,
      "Seatbelt": seatbeltPercentage,
      "Distracted": distractedPercentage,
    };

    final colorList = <Color>[
      Colors.blue,
      Colors.green,
      Colors.red,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Visualization'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Journey Results',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    PieChart(
                      dataMap: dataMap,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32.0,
                      chartRadius: MediaQuery.of(context).size.width / 2.2,
                      colorList: colorList,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Journey\nResults",
                      legendOptions: LegendOptions(
                        showLegendsInRow: true,
                        legendPosition: LegendPosition.bottom,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                        chartValueStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    if (drowsyPercentage > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Drowsy: ${drowsyPercentage.toStringAsFixed(1)}%'),
                          SizedBox(height: 8.0),
                          Text(
                            'You displayed signs of drowsiness during your journey. It\'s important to take regular breaks and ensure you are well-rested before driving.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    if (seatbeltPercentage > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Seatbelt: ${seatbeltPercentage.toStringAsFixed(1)}%'),
                          SizedBox(height: 8.0),
                          Text(
                            'You were not wearing your seatbelt during part of your journey. Always remember to buckle up for your safety.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                    if (distractedPercentage > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Distracted: ${distractedPercentage.toStringAsFixed(1)}%'),
                          SizedBox(height: 8.0),
                          Text(
                            'You were distracted during your journey. It\'s crucial to keep your focus on the road and avoid any activities that can take your attention away from driving.',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16.0),
                        ],
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
