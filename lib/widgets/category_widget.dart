import 'package:flutter/material.dart';
import 'package:tripool_app/styleguide.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../model/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final bool selectable;

  const CategoryWidget(
      {Key? key, required this.category, this.selectable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelected = !selectable;
    AppState? appState;
    if (selectable) {
      appState = Provider.of<AppState>(context);
      isSelected = appState.selectedCategoryId == category.categoryId;
    }

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          appState?.updateCategoryId(category.categoryId);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.white : Color(0x99FFFFFF), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              category.icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.white,
              size: 25,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              category.name,
              style: isSelected ? selectedCategoryTextStyle : categoryTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
