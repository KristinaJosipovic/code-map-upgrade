import 'package:flutter/material.dart';

class DietModel {
  String name;
  String iconPath;
  String level;
  String duration;
  String calorie;
  Color boxColor;
  bool viewIsSelected;

  DietModel({
    required this.name,
    required this.iconPath,
    required this.level,
    required this.duration,
    required this.calorie,
    required this.boxColor,
    required this.viewIsSelected
  });

  static List < DietModel > getDiets() {
    List < DietModel > diets = [];

    diets.add(
      DietModel(
       name: 'Python',
       iconPath: 'assets/logos/python_logo.png',
       level: 'Easy',
       duration: '30mins',
       calorie: '180kCal',
       viewIsSelected: true,
       boxColor: const Color(0xff9DCEFF)
      )
    );

    diets.add(
      DietModel(
       name: 'JavaScript',
       iconPath: 'assets/logos/javascript_logo.png',
       level: 'Easy',
       duration: '20mins',
       calorie: '230kCal',
       viewIsSelected: false,
       boxColor: const Color(0xffEEA4CE)
      )
    );

    diets.add(
        DietModel(
            name: 'Ruby',
            iconPath: 'assets/logos/ruby_logo.png',
            level: 'Easy',
            duration: '20mins',
            calorie: '230kCal',
            viewIsSelected: false,
            boxColor: const Color(0xff9DCEFF)
        )
    );

    return diets;
  }
}