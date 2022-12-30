// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/pages/news_read.dart';
import 'package:news_app_riverpod/pages/saved_news_list.dart';
import 'package:news_app_riverpod/utils/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_riverpod/utils/hive_prefs.dart';
import 'package:news_app_riverpod/widget/card_skeleton.dart';

import '../main.dart';
import '../widget/news_post_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final apiProvider = ApiProvider();
  int fetchedDataDetails = 0;
  bool isLoading = false;
  late dynamic data;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Size screenSize = MediaQuery.of(context).size;
      ref.read(providerStorage.screenWidth.notifier).state = screenSize.width;
      ref.read(providerStorage.screenHeight.notifier).state = screenSize.height;

      fetchNews();
      updateSavedNews();
    });
    super.initState();
  }

  List<dynamic> news = [];
  @override
  Widget build(BuildContext context) {
    final screenWidth = ref.watch(providerStorage.screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedNewsPage(),
                ),
              );
            },
            child: Icon(
              CupertinoIcons.bookmark_fill,
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadNewsPage(),
            ),
          );
        },
        mini: true,
        child: Icon(Icons.refresh),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                news.clear();
                fetchedDataDetails = 0;
                setState(() {});
                fetchNews();
                return Future.delayed(Duration(seconds: 1));
              },
              child: createListView(screenWidth),
            ),
          ),
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

// =============================================================================================================
// =============================================================================================================

  Future<void> fetchNews() async {
    http.Response resp = await apiProvider.getNews();
    data = jsonDecode(resp.body);
    addToList(data['articles']);
  }

  void addToList(List<dynamic> data) async {
    if (data.length > fetchedDataDetails + 5) {
      news.addAll(data.getRange(fetchedDataDetails, fetchedDataDetails + 5));
      fetchedDataDetails += 5;
    } else {
      news.addAll(data.getRange(fetchedDataDetails, data.length));
    }
    if (!isLoading) {
      setState(() {});
    }
  }

  void updateSavedNews() async {
    var savedNews = await Prefs.getSavedNews(Prefs.newsKey);
    ref.read(providerStorage.savedNews.notifier).state = savedNews;
  }

  Widget createListView(double screenWidth) {
    ScrollController scrollController = ScrollController();

    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          setState(() {});
          await Future.delayed(Duration(seconds: 3));

          addToList(data['articles']);
          isLoading = !isLoading;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.white38,
              content: Text(
                'List Updated',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              duration: Duration(milliseconds: 800),
            ),
          );
          setState(() {});
        } else {
          setState(() {});
        }
      }
    });

    return news.isNotEmpty
        ? ListView.builder(
            controller: scrollController,
            itemCount: news.length,
            itemBuilder: (context, i) {
              var curNews = news[i];
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
                  title: curNews['title'] ?? '',
                  uploadTime: curNews['publishedAt'].split('T').first ?? '',
                  imageURL: curNews['urlToImage'] ?? '',
                  content: curNews['content'] ?? '',
                  authorName: curNews['author'] ?? '',
                  source: curNews['source']['name'] ?? '',
                  screenWidth: screenWidth,
                  isFromSaved: false,
                ),
              );
            },
          )
        : ListView.builder(
            controller: scrollController,
            itemCount: 3,
            itemBuilder: (context, i) {
              return NewsSkeletonWidget();
            },
          );
  }
}
