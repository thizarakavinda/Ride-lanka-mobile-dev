// lib/core/utils/favorites_store.dart
//for testing only

class FavoritesStore {
  static final Set<String> _favoriteIds = {};

  static bool isFavorite(String id) => _favoriteIds.contains(id);

  static void toggle(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
  }
}