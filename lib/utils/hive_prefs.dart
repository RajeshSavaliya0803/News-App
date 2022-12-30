import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:news_app_riverpod/main.dart';

class Prefs {
  static const prefBox = 'prefBox';
  static const newsKey = 'savedNews';

  static Future<List<dynamic>> getSavedNews(Object newsKey) async {
    final box = await Hive.openBox(prefBox);
    return box.get(newsKey) ?? [];
  }

  static Future<void> bookmarkNews(
      dynamic news, Object newsKey, WidgetRef ref) async {
    final box = await Hive.openBox(prefBox);

    List<dynamic> newsList = box.get(newsKey) ?? [];
    newsList.add(news);
    providerStorage.addNews(ref, news);

    return box.put(newsKey, newsList);
  }

  static Future<void> removeBookmarkNews(
      int id, Object newsKey, WidgetRef ref) async {
    final box = await Hive.openBox(prefBox);

    List<dynamic> newsList = box.get(newsKey) ?? [];
    newsList.removeAt(id);
    providerStorage.removeNews(ref, id);

    return box.put(newsKey, newsList);
  }
}
