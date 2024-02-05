

class MyUser {
  static const String collectionName = 'users';
  String id;
  String fullName;
  String email;
  String number;

  // Constructor
  MyUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.number,
  });

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          fullName: json['fullName'] as String,
          email: json['email'] as String,
          number: json['number'] as String,
        );

  Map<String, dynamic> toJson() {
    return {'id': id, "fullName": fullName, 'email': email, 'number': number};
  }
}
