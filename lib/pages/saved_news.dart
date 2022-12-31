// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/main.dart';
import 'package:news_app_riverpod/pages/cat_news_page.dart';

class SavedNews extends ConsumerStatefulWidget {
  const SavedNews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedNewsState();
}

class _SavedNewsState extends ConsumerState<SavedNews> {
  @override
  Widget build(BuildContext context) {
    final savedNews = ref.watch(providerStorage.savedNews);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Saved news'),
      ),
      body: savedNews.isNotEmpty
          ? ListView.builder(
              itemCount: savedNews.length,
              itemBuilder: (context, i) {
                var curNews = savedNews[i];
                return CatNewsCard(curNews: curNews);
              },
            )
          : Center(
              child: Text('There is no saved News.'),
            ),
    );
  }
}
