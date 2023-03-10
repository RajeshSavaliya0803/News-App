// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/main.dart';
import 'package:news_app_riverpod/utils/hive_prefs.dart';
import 'package:sizer/sizer.dart';

class NewsReadPage extends ConsumerStatefulWidget {
  const NewsReadPage({
    super.key,
    required this.news,
  });
  final dynamic news;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewsReadPageState();
}

class _NewsReadPageState extends ConsumerState<NewsReadPage> {
  bool isFav = false;
  List<dynamic> savedNews = [];

  String getDays() {
    var time = DateTime.parse(widget.news['publishedAt']);
    Duration days = DateTime.now().difference(time);
    return days.inDays.toString();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForFav();
    });
    super.initState();
  }

  void checkForFav() {
    savedNews = ref.watch(providerStorage.savedNews);
    if (savedNews.isEmpty) {
      isFav = false;
      setState(() {});
    }
    for (var i = 0; i < savedNews.length; i++) {
      if (savedNews[i]['title'] == widget.news['title']) {
        isFav = true;
        setState(() {});
        break;
      } else {
        isFav = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 65.h,
              width: 100.w,
              color: Colors.amber,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.news['urlToImage'],
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 45.h,
              width: 100.w,
              padding:
                  EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w, bottom: 1.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6.h),
                  topRight: Radius.circular(6.h),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextHolderContainer(
                            text: widget.news['author'] ?? 'Unknown',
                            height: 6.h,
                            width: 40.w,
                          ),
                          SizedBox(width: 2.w),
                          TextHolderContainer(
                            text: '${getDays()} days',
                            height: 6.h,
                            width: 23.w,
                          ),
                          InkWell(
                            onTap: () async {
                              if (isFav) {
                                await Prefs.removeBookmarkNews(
                                    widget.news, Prefs.newsKey, ref);
                              } else {
                                await Prefs.bookmarkNews(
                                    widget.news, Prefs.newsKey, ref);
                              }
                              checkForFav();
                            },
                            child: Container(
                              height: 6.h,
                              width: 6.h,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(6.h),
                              ),
                              child: Icon(isFav
                                  ? Icons.favorite
                                  : Icons.favorite_outline),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.news['title'],
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.news['content'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class NewsReadPage extends StatefulWidget {
//   const NewsReadPage({
//     super.key,
//     required this.news,
//   });
//   final dynamic news;
//   @override
//   State<NewsReadPage> createState() => _NewsReadPageState();
// }

// class _NewsReadPageState extends State<NewsReadPage> {

// }

class TextHolderContainer extends StatelessWidget {
  const TextHolderContainer({
    Key? key,
    required this.text,
    required this.height,
    required this.width,
  }) : super(key: key);
  final String text;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(6.h),
      ),
      child: Center(
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}
