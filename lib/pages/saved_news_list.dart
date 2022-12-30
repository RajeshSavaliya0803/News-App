// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/main.dart';
import 'package:news_app_riverpod/widget/news_post_widget.dart';

import 'news_read.dart';

class SavedNewsPage extends ConsumerStatefulWidget {
  const SavedNewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedNewsPageState();
}

class _SavedNewsPageState extends ConsumerState<SavedNewsPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(providerStorage.screenWidth);
    final savedNews = ref.watch(providerStorage.savedNews);

    return Scaffold(
      appBar: AppBar(title: Text('Saved News')),
      body: ListView.builder(
        itemCount: savedNews.length,
        itemBuilder: (context, i) {
          dynamic curNews = savedNews[i];
          return InkWell(
            onTap: () {
              ref.read(providerStorage.curNews.notifier).state = curNews;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadNewsPage(),
                ),
              );
            },
            child: NewsPostWidget(
              screenWidth: screenWidth,
              title: curNews['title'],
              uploadTime: curNews['publishedAt'],
              imageURL: curNews['urlToImage'],
              authorName: "${curNews['source']['name']}",
              content: curNews['content'],
              isFromSaved: true,
              index: i,
            ),
          );
        },
      ),
    );
  }
}
