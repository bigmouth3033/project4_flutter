import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project4_flutter/features/property_detail/property_detail.dart';
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PropertyDetail()),
            );
          },
          child: const Text('Property Detail'),
        ),
      ),
    );
  }
}
