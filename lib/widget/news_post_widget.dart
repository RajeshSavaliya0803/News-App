// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app_riverpod/utils/hive_prefs.dart';

// ignore: must_be_immutable
class NewsPostWidget extends ConsumerWidget {
  NewsPostWidget({
    super.key,
    required this.screenWidth,
    required this.title,
    required this.uploadTime,
    required this.imageURL,
    required this.authorName,
    required this.isFromSaved,
    required this.content,
    this.source,
    this.index,
  });
  final String title;
  final String uploadTime;
  final String imageURL;
  final String authorName;
  final String? source;
  final String content;
  final double screenWidth;
  final bool isFromSaved;
  int? index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            uploadTime,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.grey[400],
            height: 210,
            width: screenWidth,
            child: Image.network(
              imageURL,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Text('Image Not found.');
              },
            ),
          ),
          SizedBox(height: 8),
          isFromSaved
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$authorName / $source',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Prefs.removeBookmarkNews(index!, Prefs.newsKey, ref);
                      },
                      child: Icon(Icons.delete),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    SizedBox(
                      width: screenWidth * 0.5,
                      height: 20,
                      child: Text(
                        '$authorName ($source)',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Icon(
                          Icons.send,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            dynamic newNews = {
                              'title': title,
                              'publishedAt': uploadTime,
                              'urlToImage': imageURL,
                              'source': {'name': authorName},
                              'content': content,
                            };

                            await Prefs.bookmarkNews(
                                newNews, Prefs.newsKey, ref);
                          },
                          child: Icon(
                            CupertinoIcons.bookmark,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          Divider(thickness: 2),
        ],
      ),
    );
  }
}
