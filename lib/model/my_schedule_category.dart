import 'package:flutter/material.dart';

Map<String, int> Mycategoryindex = {
  "All": 0,
  "Created": 1,
  "Joined": 2,
  "Requested": 3
};

class myCategory {
  final int categoryId;
  final String name;
  final IconData icon;

  myCategory(
      {required this.categoryId, required this.name, required this.icon});
}

final AllmyCategory = myCategory(
  categoryId: 0,
  name: "All",
  icon: Icons.search_off_rounded,
);
final CreatedCategory = myCategory(
  categoryId: 1,
  name: "Created",
  icon: Icons.plus_one_rounded,
);

//Entertainment won't fit, had to change category name to events
final JoinedCategory = myCategory(
  categoryId: 2,
  name: "Joined",
  icon: Icons.join_full_rounded,
);

final RequestedCategory = myCategory(
  categoryId: 3,
  name: "Requested",
  icon: Icons.request_page_rounded,
);

final mycategories = [
  AllmyCategory,
  CreatedCategory,
  JoinedCategory,
  RequestedCategory,
];
