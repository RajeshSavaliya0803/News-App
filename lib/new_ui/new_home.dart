// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_riverpod/new_ui/saved_news.dart';
import 'package:news_app_riverpod/utils/api_provider.dart';

import 'first_page.dart';
import 'second_page.dart';

class NewUiHomePage extends StatefulWidget {
  const NewUiHomePage({super.key});

  @override
  State<NewUiHomePage> createState() => _NewUiHomePageState();
}

class _NewUiHomePageState extends State<NewUiHomePage> {
  List<dynamic> news = [];
  late dynamic bannerNews;
  List<IconData> navigationIcons = [Icons.home, Icons.category_rounded];
  int activeIndex = 0;

  @override
  void initState() {
    fetchApiData();
    super.initState();
  }

  void fetchApiData() async {
    http.Response resp = await ApiProvider().getNews();
    var data = jsonDecode(resp.body);
    news = data['articles'];
    bannerNews = news[0];
    news.removeAt(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedNews(),
                ),
              );
            },
            icon: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.black,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        activeColor: Colors.amber,
        inactiveColor: Colors.grey[700],
        icons: navigationIcons,
        activeIndex: activeIndex,
        notchSmoothness: NotchSmoothness.smoothEdge,
        gapLocation: GapLocation.center,
        onTap: (v) {
          activeIndex = v;
          setState(() {});
        },
      ),
      body: news.isNotEmpty
          ? activeIndex == 0
              ? FirstPage(bannerNews: bannerNews, news: news)
              : SecondPage()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
