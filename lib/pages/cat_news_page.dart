// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_riverpod/utils/api_provider.dart';
import 'package:sizer/sizer.dart';

import 'news_read_page.dart';

class CategoryNewsPage extends StatefulWidget {
  const CategoryNewsPage({
    super.key,
    required this.newsTopic,
  });
  final String newsTopic;
  @override
  State<CategoryNewsPage> createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  List<dynamic> newsList = [];
  @override
  void initState() {
    getNewsList();
    super.initState();
  }

  void getNewsList() async {
    http.Response res = await ApiProvider().getNews(newsCat: widget.newsTopic);
    var data = jsonDecode(res.body);
    newsList = data['articles'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      itemCount: newsList.length,
      itemBuilder: (context, i) {
        var curNews = newsList[i];
        return CatNewsCard(curNews: curNews);
      },
    );
  }
}

class CatNewsCard extends StatelessWidget {
  const CatNewsCard({
    Key? key,
    required this.curNews,
  }) : super(key: key);

  final dynamic curNews;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsReadPage(news: curNews),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                curNews['urlToImage'],
                height: 15.h,
                width: 15.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: SizedBox(
                    height: 15.h,
                    width: 15.h,
                    child: Center(
                      child: Text('Image not available.'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.h),
            SizedBox(
              width: 57.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    curNews['title'] ?? 'No Title',
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(curNews['publishedAt'].split('T').first),
                      SizedBox(
                        width: 30.w,
                        child: Text(
                          curNews['source']['name'],
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 1.h),
          ],
        ),
      ),
    );
  }
}
