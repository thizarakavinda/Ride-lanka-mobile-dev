import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_lanka/core/services/api_client.dart';
import '../models/user_model.dart';

class AuthService {
  Future<User?> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger().e('Weak password');
      } else if (e.code == 'email-already-in-use') {
        Logger().e('Email already in use');
      } else {
        Logger().e('Firebase register error: ${e.code}');
      }
      return null;
    }
  }

  Future<void> saveProfile(UserModel user) async {
    try {
      final response = await ApiClient.post(
        '/api/users/profile',
        user.toProfilePayload(),
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        throw Exception(body['error'] ?? 'Failed to save profile');
      }
    } catch (e) {
      Logger().e('saveProfile error: $e');
      rethrow;
    }
  }

  Future<UserModel?> fetchProfile() async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return null;

      final response = await ApiClient.get('/api/users/profile');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromMap(data, firebaseUser.uid);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch profile: ${response.body}');
      }
    } catch (e) {
      Logger().e('fetchProfile error: $e');
      return null;
    }
  }

  Future<User?> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return null;
      } else {
        Logger().e('Firebase sign in error: ${e.code}');
      }
      return null;
    } catch (e) {
      Logger().e('signInUser error: $e');
      return null;
    }
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
