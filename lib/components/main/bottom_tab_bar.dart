import 'package:easy_peasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_peasy/size_config.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar(
      {Key? key, required this.finalIndex, required this.onChangedTab})
      : super(key: key);
  final int finalIndex;
  final ValueChanged<int> onChangedTab;
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      child: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTabItem(
              0,
              Icon(
                Icons.book,
                size: getProportionateScreenWidth(25),
              ),
            ),
            buildTabItem(
              1,
              Icon(
                Icons.apps,
                size: getProportionateScreenWidth(25),
              ),
            ),
            buildTabItem(
              2,
              Icon(
                Icons.person,
                size: getProportionateScreenWidth(25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabItem(int index, Icon icon) {
    final isSelected = index == finalIndex;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? kMainPink : kMainPurple.withOpacity(0.5),
      ),
      child: IconButton(
        icon: icon,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () => onChangedTab(index),
      ),
    );
  }
}
