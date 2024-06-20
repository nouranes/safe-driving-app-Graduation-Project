class Journey {
  String startDirection;
  String endDirection;
  String duration;
  String distance;

  Journey({
    required this.startDirection,
    required this.endDirection,
    required this.duration,
    required this.distance,
  });

  Journey.fromJson(Map<String, dynamic> json)
      : this(
          startDirection: json['startDirection'] as String,
          endDirection: json['endDirection'] as String,
          duration: json['duration'] as String,
          distance: json['distance'] as String,
        );

  Map<String, dynamic> toJson() {
    return {
      'startDirection': startDirection,
      'endDirection': endDirection,
      'duration': duration,
      'distance': distance,
    };
  }
}
class MyUser {
  static const String collectionName = 'users';
  String id;
  String fullName;
  String email;
  String number;
  List<Journey> journeyHistory;
  double drowsyPercentage;
  double noSeatBeltPercentage;
  double distractedPercentage;
  double rating; // Add the rating field

  // Constructor
  MyUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.number,
    required this.journeyHistory,
    this.drowsyPercentage = 0,
    this.noSeatBeltPercentage = 0,
    this.distractedPercentage = 0,
    this.rating = 0, // Initialize rating
  });

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          fullName: json['fullName'] as String,
          email: json['email'] as String,
          number: json['number'] as String,
          journeyHistory: (json['journeyHistory'] as List<dynamic>?)
              ?.map((journey) => Journey.fromJson(journey as Map<String, dynamic>))
              .toList() ?? [],
          drowsyPercentage: (json['drowsyPercentage'] as num?)?.toDouble() ?? 0,
          noSeatBeltPercentage: (json['noSeatBeltPercentage'] as num?)?.toDouble() ?? 0,
          distractedPercentage: (json['distractedPercentage'] as num?)?.toDouble() ?? 0,
          rating: json['rating'] as double? ?? 0, // Deserialize rating
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'number': number,
      'journeyHistory': journeyHistory.map((journey) => journey.toJson()).toList(),
      'drowsyPercentage': drowsyPercentage,
      'noSeatBeltPercentage': noSeatBeltPercentage,
      'distractedPercentage': distractedPercentage,
      'rating': rating, // Serialize rating
    };
  }
}
