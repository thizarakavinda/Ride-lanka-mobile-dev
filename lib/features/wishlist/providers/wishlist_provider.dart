import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  Set<String> _favoriteIds = {};
  bool _isLoading = false;

  Set<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;

  WishlistProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites({bool force = false}) async {
    if (!force && _favoriteIds.isNotEmpty) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data()!.containsKey('wishlist')) {
        final List<dynamic> list = doc.data()!['wishlist'];
        _favoriteIds = list.map((e) => e.toString()).toSet();
      }
    } catch (e) {
      debugPrint("Error loading wishlist: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggleFavorite(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (_favoriteIds.contains(id)) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
      notifyListeners();
      return;
    }

    final isAdding = !_favoriteIds.contains(id);
    if (isAdding) {
      _favoriteIds.add(id);
    } else {
      _favoriteIds.remove(id);
    }
    notifyListeners();

    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      if (isAdding) {
        await userRef.set({
          'wishlist': FieldValue.arrayUnion([id]),
        }, SetOptions(merge: true));
      } else {
        await userRef.set({
          'wishlist': FieldValue.arrayRemove([id]),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      if (isAdding) {
        _favoriteIds.remove(id);
      } else {
        _favoriteIds.add(id);
      }
      notifyListeners();
      debugPrint("Error toggling favorite: $e");
    }
  }
}
