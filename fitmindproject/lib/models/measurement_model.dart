import 'package:cloud_firestore/cloud_firestore.dart';

/// Body Measurement model for tracking physical progress
/// Step 3 requirement: id, createdBy, createdAt fields + app-specific fields
class MeasurementModel {
  final String id;
  final double weight; // kg
  final double? bodyFat; // percentage
  final double? muscleMass; // kg
  final double? bmi;
  final double? chest; // cm
  final double? waist; // cm
  final double? hips; // cm
  final double? arms; // cm
  final double? thighs; // cm
  final String createdBy; // user ID (Step 3 requirement)
  final DateTime createdAt; // timestamp (Step 3 requirement)
  final String? notes;

  MeasurementModel({
    required this.id,
    required this.weight,
    this.bodyFat,
    this.muscleMass,
    this.bmi,
    this.chest,
    this.waist,
    this.hips,
    this.arms,
    this.thighs,
    required this.createdBy,
    required this.createdAt,
    this.notes,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'bodyFat': bodyFat,
      'muscleMass': muscleMass,
      'bmi': bmi,
      'chest': chest,
      'waist': waist,
      'hips': hips,
      'arms': arms,
      'thighs': thighs,
      'createdBy': createdBy, // Step 3 requirement
      'createdAt': Timestamp.fromDate(createdAt), // Step 3 requirement
      'notes': notes,
    };
  }

  /// Create from Firestore Map
  factory MeasurementModel.fromMap(Map<String, dynamic> map) {
    return MeasurementModel(
      id: map['id'] ?? '',
      weight: (map['weight'] ?? 0).toDouble(),
      bodyFat: map['bodyFat']?.toDouble(),
      muscleMass: map['muscleMass']?.toDouble(),
      bmi: map['bmi']?.toDouble(),
      chest: map['chest']?.toDouble(),
      waist: map['waist']?.toDouble(),
      hips: map['hips']?.toDouble(),
      arms: map['arms']?.toDouble(),
      thighs: map['thighs']?.toDouble(),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notes: map['notes'],
    );
  }

  /// Create from Firestore DocumentSnapshot
  factory MeasurementModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeasurementModel.fromMap(data);
  }

  MeasurementModel copyWith({
    String? id,
    double? weight,
    double? bodyFat,
    double? muscleMass,
    double? bmi,
    double? chest,
    double? waist,
    double? hips,
    double? arms,
    double? thighs,
    String? createdBy,
    DateTime? createdAt,
    String? notes,
  }) {
    return MeasurementModel(
      id: id ?? this.id,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      muscleMass: muscleMass ?? this.muscleMass,
      bmi: bmi ?? this.bmi,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      hips: hips ?? this.hips,
      arms: arms ?? this.arms,
      thighs: thighs ?? this.thighs,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  /// Calculate BMI from weight and height
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }
}



