import 'package:cloud_firestore/cloud_firestore.dart';

/// User model for Firebase Authentication and Firestore
/// Step 3 requirement: Model class with proper serialization
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  final String? photoUrl;
  
  // User profile data from registration
  final int? age;
  final String? gender;
  final double? height; // cm
  final double? weight; // kg
  final String? fitnessGoal;
  final String? activityLevel;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
    this.photoUrl,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.fitnessGoal,
    this.activityLevel,
  });

  /// Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'photoUrl': photoUrl,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'fitnessGoal': fitnessGoal,
      'activityLevel': activityLevel,
    };
  }

  /// Create UserModel from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      photoUrl: map['photoUrl'],
      age: map['age'],
      gender: map['gender'],
      height: map['height']?.toDouble(),
      weight: map['weight']?.toDouble(),
      fitnessGoal: map['fitnessGoal'],
      activityLevel: map['activityLevel'],
    );
  }

  /// Create UserModel from Firestore DocumentSnapshot
  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
    String? photoUrl,
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? fitnessGoal,
    String? activityLevel,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}



