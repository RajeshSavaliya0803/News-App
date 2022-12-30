// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget(
      {super.key,
      required this.title,
      required this.time,
      required this.author,
      required this.imageUrl});

  final String title;
  final String time;
  final String author;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: EdgeInsets.only(right: 15, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Text(
              title,
              maxLines: 2,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(time),
            Text(
              'by $author',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
