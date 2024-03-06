import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  CustomBottomNavigationBar({required this.onTabSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onTabSelected(0), // Placeholder function for home action
            icon: Icon(Icons.home),
            color: selectedIndex == 0 ? Color(0xFF26547C) : Color(0xFF26547C).withOpacity(0.4), // Highlight the selected tab
          ),
          IconButton(
            onPressed: () => onTabSelected(1),
            icon: Icon(Icons.fitness_center),
            color: selectedIndex == 1 ? Color(0xFF26547C) : Color(0xFF26547C).withOpacity(0.4),
          ),
          IconButton(
            onPressed: () => onTabSelected(2),
            icon: Icon(Icons.favorite),
            color: selectedIndex == 2 ? Color(0xFF26547C) : Color(0xFF26547C).withOpacity(0.4),
          ),
          IconButton(
            onPressed: () => onTabSelected(3),
            icon: Icon(Icons.local_hospital),
            color: selectedIndex == 3 ? Color(0xFF26547C) : Color(0xFF26547C).withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}