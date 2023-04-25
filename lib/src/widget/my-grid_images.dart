import 'dart:io';

import 'package:flutter/material.dart';

class MyGridImages extends StatelessWidget {
  //final List images;
  final int? itemCount;
  final itemBuilder;

  MyGridImages({super.key, required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      addAutomaticKeepAlives: true,
      padding: EdgeInsets.all(0.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.0, //3.0,
        mainAxisSpacing: 3.0, //3.0,
        childAspectRatio: 1 / 1.9,
      ),
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
