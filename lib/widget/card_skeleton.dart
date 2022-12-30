// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class NewsSkeletonWidget extends StatefulWidget {
  const NewsSkeletonWidget({super.key});

  @override
  State<NewsSkeletonWidget> createState() => _NewsSkeletonWidgetState();
}

class _NewsSkeletonWidgetState extends State<NewsSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation anim;
  double gradPos = 0.0;

  @override
  void initState() {
    initAnim();
    super.initState();
  }

  void initAnim() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    anim = Tween(begin: 0.0, end: 0.9).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget dummyContainer(
      {double? width = double.infinity, double? height = 16}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[300]!, Colors.white],
          stops: [0.0 + anim.value, 0.10 + anim.value, 0.20 + anim.value],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          dummyContainer(height: 60),
          SizedBox(height: 8),
          dummyContainer(),
          SizedBox(height: 8),
          dummyContainer(height: 180),
          SizedBox(height: 8),
          dummyContainer(height: 20),
        ],
      ),
    );
  }
}
