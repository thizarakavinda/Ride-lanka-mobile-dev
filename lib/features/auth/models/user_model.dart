class UserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String dob;
  final String phone;
  final List<String> interests;
  final String travelType;
  final String budget;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.phone,
    required this.interests,
    required this.travelType,
    required this.budget,
    required this.createdAt,
  });

  // used when sending to backend POST /api/users/profile
  Map<String, dynamic> toProfilePayload() {
    return {'name': '$firstName $lastName', 'interests': interests};
  }

  // local representation (used internally if needed)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'dob': dob,
      'phone': phone,
      'preferences': {
        'interests': interests,
        'travelType': travelType,
        'budget': budget,
      },
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // fromMap now expects a plain REST JSON response (no Firestore Timestamps)
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    final prefs = map['preferences'] as Map<String, dynamic>? ?? {};
    return UserModel(
      uid: uid,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      dob: map['dob'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      interests: List<String>.from(prefs['interests'] ?? []),
      travelType: prefs['travelType'] as String? ?? '',
      budget: prefs['budget'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
