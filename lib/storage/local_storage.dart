import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String watchlistKey = 'watchlist';

  Future<List<String>> getWatchlist() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(watchlistKey) ?? [];
  }

  Future<void> saveWatchlist(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(watchlistKey, ids);
  }

  Future<void> addWatchlist(String id) async {
    final ids = await getWatchlist();

    if (!ids.contains(id)) {
      ids.add(id);
    }

    await saveWatchlist(ids);
  }

  Future<void> removeWatchlist(String id) async {
    final ids = await getWatchlist();

    ids.remove(id);

    await saveWatchlist(ids);
  }
}
