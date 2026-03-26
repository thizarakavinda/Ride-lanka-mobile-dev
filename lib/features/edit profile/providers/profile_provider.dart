import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  bool _isLoadingProfile = false;
  bool get isLoadingProfile => _isLoadingProfile;

  String _name = '';
  String get name => _name;

  String _phone = '';
  String get phone => _phone;

  String _photoUrl = '';
  String get photoUrl => _photoUrl;

  File? _pickedImage;
  File? get pickedImage => _pickedImage;

  int _xp = 0;
  int get xp => _xp;

  Future<void> loadProfile() async {
    _isLoadingProfile = true;
    notifyListeners();

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _name = data['name'] ?? '';
        _phone = data['phone'] ?? '';
        _photoUrl = data['photoUrl'] ?? '';
        _xp = data['xp'] ?? 0;
      }
    } catch (e) {
      debugPrint('loadProfile error: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (picked != null) {
        _pickedImage = File(picked.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('pickImage error: $e');
    }
  }

  Future<String?> _uploadImage(File file) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      final storage = FirebaseStorage.instanceFor(bucket: 'profilePhotos');
      final ref = storage.ref().child('$uid.jpg');

      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final url = await uploadTask.ref.getDownloadURL();
      debugPrint('Upload success to bucket: profilePhotos. URL: $url');
      return url;
    } catch (e) {
      debugPrint('_uploadImage (bucket: profilePhotos) error: $e');

      try {
        debugPrint(
          'Attempting fallback to default bucket /profilePhotos folder...',
        );
        final ref = _storage.ref().child('profilePhotos').child('$uid.jpg');
        final uploadTask = await ref.putFile(
          file,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        final url = await uploadTask.ref.getDownloadURL();
        debugPrint('Fallback upload success. URL: $url');
        return url;
      } catch (e2) {
        debugPrint('Fallback upload error: $e2');
        return null;
      }
    }
  }

  Future<bool> saveProfile({
    required String name,
    required String phone,
  }) async {
    _isSaving = true;
    notifyListeners();

    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;

      String? newPhotoUrl;

      if (_pickedImage != null) {
        newPhotoUrl = await _uploadImage(_pickedImage!);
      }

      final Map<String, dynamic> updates = {
        'name': name.trim(),
        'phone': phone.trim(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (newPhotoUrl != null) {
        updates['photoUrl'] = newPhotoUrl;
        _photoUrl = newPhotoUrl;
      }

      await _firestore.collection('users').doc(uid).update(updates);

      _name = name.trim();
      _phone = phone.trim();
      _pickedImage = null;

      return true;
    } catch (e) {
      debugPrint('saveProfile error: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearPickedImage() {
    _pickedImage = null;
    notifyListeners();
  }
}
