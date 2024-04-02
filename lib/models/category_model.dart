import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: 'Proceduralno',
        iconPath: 'assets/logos/procedural_programming.jpg',
        boxColor: const Color(0xff92A3FD),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Funkcionalno',
        iconPath: 'assets/logos/functional_programming.png',
        boxColor: const Color(0xffC58BF2),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'OOP',
        iconPath: 'assets/logos/oop.png',
        boxColor: const Color(0xff92A3FD),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Skriptovano',
        iconPath: 'assets/logos/scripting.png',
        boxColor: const Color(0xffC58BF2),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Logičko',
        iconPath: 'assets/logos/logic.png',
        boxColor: const Color(0xff92A3FD),
      ),
    );

    categories.add(
      CategoryModel(
        name: 'Ezoterično',
        iconPath: 'assets/logos/esoteric.jpg',
        boxColor: const Color(0xffC58BF2),
      ),
    );

    return categories;
  }
}
