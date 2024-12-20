import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project4_flutter/features/travel/api/travel_api.dart';
import 'package:project4_flutter/features/travel/widgets/travel_category.dart';
import 'package:project4_flutter/features/travel/widgets/travel_header.dart';

class Travel extends StatefulWidget {
  const Travel({super.key});

  @override
  State<Travel> createState() => _TravelState();
}

class _TravelState extends State<Travel> {
  int categoryId = 0;

  void changeCategoryId(int value) {
    setState(() {
      categoryId = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TravelHeader(),
      body: Column(
        children: [
          TravelCategory(categoryId, changeCategoryId),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(20, (index) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 400,
                        width: double.maxFinite,
                        child: Card(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "aaaaaa",
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("bbbbbbbbb"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
