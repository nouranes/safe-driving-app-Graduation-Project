import 'package:final_project/_pages/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatelessWidget {
    static String routeName = 'jdcn';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journey History'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _fetchJourneyHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No journey history found'));
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            List<dynamic> journeys = userData['journeyHistory'] ?? [];

            return ListView.builder(
              itemCount: journeys.length,
              itemBuilder: (context, index) {
                Journey journey = Journey.fromJson(journeys[index] as Map<String, dynamic>);
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    title: Text('${journey.startDirection} to ${journey.endDirection}'),
                    subtitle: Text('Distance: ${journey.distance}, Duration: ${journey.duration}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> _fetchJourneyHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    } else {
      throw Exception('User not logged in');
    }
  }
}
