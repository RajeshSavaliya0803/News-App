// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/main.dart';

class ReadNewsPage extends ConsumerStatefulWidget {
  const ReadNewsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadNewsPageState();
}

class _ReadNewsPageState extends ConsumerState<ReadNewsPage> {
  @override
  Widget build(BuildContext context) {
    final curNews = ref.watch(providerStorage.curNews);
    return Scaffold(
      appBar: AppBar(
        title: Text('Read News'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                curNews['publishedAt'],
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 12),
              Text(
                curNews['title'],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "By ${curNews['author']}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),
              Image.network(
                curNews['urlToImage'],
                width: ref.watch(providerStorage.screenWidth),
              ),
              SizedBox(height: 12),
              Text(curNews['content']),
            ],
          ),
        ),
      ),
    );
  }
}
