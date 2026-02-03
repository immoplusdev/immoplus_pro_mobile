import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTabSelector extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final Function(int) onTabSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;

  const CustomTabSelector({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onTabSelected,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = selectedColor ?? HexColor('#2072ca');

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedIndex == index ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: selectedIndex == index
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : unselectedColor ?? Colors.white.withOpacity(0.7),
                      fontWeight: selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                    child: Text(tabs[index]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
