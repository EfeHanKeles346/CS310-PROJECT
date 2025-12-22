import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_data.dart';

class UserDataService extends ChangeNotifier {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal() {
    _loadUserData();
  }
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserData? _userData;
  static const String _userDataKey = 'user_data';
  
  UserData? get userData => _userData;
  
  bool get hasUserData => _userData != null;
  
  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;
  
  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      
      if (userDataString != null) {
        debugPrint('UserDataService: Loading data from storage');
        final Map<String, dynamic> dataMap = jsonDecode(userDataString);
        _userData = UserData.fromMap(dataMap);
        debugPrint('UserDataService: Loaded - Weight: ${_userData?.weight}, Initial: ${_userData?.initialWeight}, Target: ${_userData?.targetWeight}');
        notifyListeners();
      } else {
        debugPrint('UserDataService: No data found in storage');
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }
  
  // Save user data to SharedPreferences, memory, and Firebase
  Future<void> saveUserData(UserData data) async {
    _userData = data;
    debugPrint('UserDataService: Saving - Weight: ${data.weight}, Initial: ${data.initialWeight}, Target: ${data.targetWeight}, Goal: ${data.primaryGoal}');
    notifyListeners();
    
    // Save to local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = jsonEncode(data.toMap());
      await prefs.setString(_userDataKey, userDataString);
      debugPrint('UserDataService: Data saved successfully to local storage');
    } catch (e) {
      debugPrint('Error saving user data to local storage: $e');
    }
    
    // Save to Firebase
    await _saveToFirebase();
  }
  
  // Update user data partially - saves to both local and Firebase
  Future<void> updateUserData(UserData data) async {
    if (_userData != null) {
      debugPrint('UserDataService: Updating - New Weight: ${data.weight}, Preserved Initial: ${_userData!.initialWeight}');
      _userData = _userData!.copyWith(
        name: data.name,
        age: data.age,
        height: data.height,
        weight: data.weight,
        initialWeight: data.initialWeight ?? _userData!.initialWeight, // Preserve initial weight
        gender: data.gender,
        primaryGoal: data.primaryGoal,
        targetWeight: data.targetWeight,
        trainingExperience: data.trainingExperience,
        bodyFatPercentage: data.bodyFatPercentage ?? _userData!.bodyFatPercentage,
        muscleMass: data.muscleMass ?? _userData!.muscleMass,
      );
      debugPrint('UserDataService: After update - Weight: ${_userData!.weight}, Initial: ${_userData!.initialWeight}');
    } else {
      debugPrint('UserDataService: No existing data, creating new');
      _userData = data;
    }
    notifyListeners();
    
    // Save to local SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = jsonEncode(_userData!.toMap());
      await prefs.setString(_userDataKey, userDataString);
      debugPrint('UserDataService: Data updated successfully in local storage');
    } catch (e) {
      debugPrint('Error updating user data in local storage: $e');
    }
    
    // Save to Firebase Firestore
    await _saveToFirebase();
  }
  
  /// Save current user data to Firebase
  Future<void> _saveToFirebase() async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('UserDataService: No user logged in, skipping Firebase sync');
      return;
    }
    
    if (_userData == null) {
      debugPrint('UserDataService: No user data to save');
      return;
    }
    
    try {
      // Save to users collection using merge to preserve existing fields
      await _firestore.collection('users').doc(userId).set({
        'displayName': _userData!.name,
        'age': _userData!.age,
        'height': _userData!.height,
        'weight': _userData!.weight,
        'initialWeight': _userData!.initialWeight,
        'gender': _userData!.gender,
        'fitnessGoal': _userData!.primaryGoal,
        'targetWeight': _userData!.targetWeight,
        'trainingExperience': _userData!.trainingExperience,
        'bodyFatPercentage': _userData!.bodyFatPercentage,
        'muscleMass': _userData!.muscleMass,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      debugPrint('UserDataService: Data synced to Firebase successfully');
    } catch (e) {
      debugPrint('Error syncing user data to Firebase: $e');
    }
  }
  
  /// Load user data from Firebase
  Future<void> loadFromFirebase() async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint('UserDataService: No user logged in');
      return;
    }
    
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        _userData = UserData(
          name: data['displayName'] ?? '',
          age: data['age'] ?? 0,
          height: (data['height'] ?? 0).toDouble(),
          weight: (data['weight'] ?? 0).toDouble(),
          initialWeight: data['initialWeight']?.toDouble(),
          gender: data['gender'] ?? 'Male',
          primaryGoal: data['fitnessGoal'] ?? 'lose_weight',
          targetWeight: data['targetWeight']?.toDouble(),
          trainingExperience: data['trainingExperience'] ?? 'intermediate',
          bodyFatPercentage: data['bodyFatPercentage']?.toDouble(),
          muscleMass: data['muscleMass']?.toDouble(),
        );
        notifyListeners();
        
        // Also update local storage
        final prefs = await SharedPreferences.getInstance();
        final userDataString = jsonEncode(_userData!.toMap());
        await prefs.setString(_userDataKey, userDataString);
        
        debugPrint('UserDataService: Loaded data from Firebase');
      }
    } catch (e) {
      debugPrint('Error loading user data from Firebase: $e');
    }
  }
  
  // Clear user data
  Future<void> clearUserData() async {
    _userData = null;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
    } catch (e) {
      debugPrint('Error clearing user data: $e');
    }
  }
  
  // Refresh data from storage (useful for hot reload)
  Future<void> refresh() async {
    await _loadUserData();
  }
}
