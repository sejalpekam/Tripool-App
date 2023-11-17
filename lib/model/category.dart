import 'package:flutter/material.dart';

Map<String, int> categoryindex = {
  "All": 0,
  "Events": 1,
  "Meetup": 2,
  "Outdoor": 3,
  "Sports": 4,
  "Other": 5
};

class Category {
  final int categoryId;
  final String name;
  final IconData icon;

  Category({required this.categoryId, required this.name, required this.icon});
}

final allCategory = Category(
  categoryId: 0,
  name: "All",
  icon: Icons.search,
);

//Entertainment won't fit, had to change category name to events
final entertainmentCategory = Category(
  categoryId: 1,
  name: "Events",
  icon: Icons.movie,
);

final meetUpCategory = Category(
  categoryId: 2,
  name: "Meetup",
  icon: Icons.location_on,
);

final outdoorCategory = Category(
  categoryId: 3,
  name: "Outdoor",
  icon: Icons.map,
);

final sportsCategory = Category(
  categoryId: 4,
  name: "Sports",
  icon: Icons.sports_basketball,
);

final otherCategory = Category(
  categoryId: 5,
  name: "Other",
  icon: Icons.circle,
);

final categories = [
  allCategory,
  entertainmentCategory,
  meetUpCategory,
  outdoorCategory,
  sportsCategory,
  otherCategory,
];
