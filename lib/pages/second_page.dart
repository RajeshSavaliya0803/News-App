// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:news_app_riverpod/utils/api_provider.dart';
import 'package:sizer/sizer.dart';

import 'cat_news_page.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<String> catList = ApiProvider().newsCatagory;

  List<Widget> tabs() {
    List<Widget> tab = [];
    for (var i = 0; i < catList.length; i++) {
      tab.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(
            catList[i],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return tab;
  }

  List<Widget> tabViews() {
    List<Widget> tabs = [];

    for (var i = 0; i < catList.length; i++) {
      // tabs.add(Center(child: Text(catList[i])));
      tabs.add(
        CategoryNewsPage(newsTopic: catList[i]),
      );
    }

    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 6.h, top: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Discover',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'News from all over the world',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
            initialIndex: 0,
            length: catList.length,
            child: Column(
              children: [
                TabBar(
                  tabs: tabs(),
                  isScrollable: true,
                  indicatorColor: Colors.grey,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                ),
                Expanded(
                  child: TabBarView(
                    children: tabViews(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
