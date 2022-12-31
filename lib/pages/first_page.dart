// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/pages/news_read_page.dart';
import 'package:sizer/sizer.dart';

import '../widget/home_post_widget.dart';

class FirstPage extends ConsumerWidget {
  const FirstPage({
    Key? key,
    required this.bannerNews,
    required this.news,
  }) : super(key: key);

  final dynamic bannerNews;
  final List news;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 55.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  child: Image.network(
                    bannerNews['urlToImage'],
                    errorBuilder: (context, error, stackTrace) => Text('data'),
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: const [
                            Color.fromARGB(200, 0, 0, 0),
                            Colors.transparent
                          ],
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(100, 255, 255, 255),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              'News of the day',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            bannerNews['title'],
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsReadPage(
                                    news: bannerNews,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Learn more  ->',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Breaking News',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      'More',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 31.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: news.length,
                    itemBuilder: (context, i) {
                      var curNews = news[i];
                      return LongPressDraggable<Map<String, dynamic>>(
                        feedback: Image.network(
                          curNews['urlToImage'],
                          height: 100,
                          width: 100,
                        ),
                        data: curNews,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsReadPage(news: curNews),
                            ),
                          ),
                          child: NewsWidget(
                            title: curNews['title'],
                            time: curNews['publishedAt'],
                            author: curNews['author'] ?? 'Unknown',
                            imageUrl: curNews['urlToImage'],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
