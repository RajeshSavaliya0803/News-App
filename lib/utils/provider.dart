import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProviderStorage {
  static const String apiKey = '7c641b7b83704434a6d182ca1eee7497';

  final screenWidth = StateProvider((ref) => 0.0, name: 'width');
  final screenHeight = StateProvider((ref) => 0.0, name: 'height');
  final curNews = StateProvider((ref) => {}, name: 'curNews');
  final savedNews = StateNotifierProvider<SavedNewsNotifier, List<dynamic>>(
      (ref) => SavedNewsNotifier());

  void addNews(WidgetRef ref, dynamic news) {
    ref.read(savedNews.notifier).addSavedNews(news);
  }

  void removeNews(WidgetRef ref, int index) {
    ref.read(savedNews.notifier).removeSavedNews(index);
  }
}

class SavedNewsNotifier extends StateNotifier<List<dynamic>> {
  SavedNewsNotifier() : super([]);

  void addSavedNews(dynamic newsTitle) {
    state = [...state, newsTitle];
  }

  void removeSavedNews(int index) {
    List<dynamic> tempList = [...state];
    tempList.removeAt(index);
    state = tempList;
  }
}
