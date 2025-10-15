// lib/widgets/multi_select_chip.dart
import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> itemList;
  final List<String> initialValue;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip({
    super.key,
    required this.itemList,
    required this.onSelectionChanged,
    required this.initialValue,
  });

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: widget.itemList.map((item) {
        final isSelected = selectedItems.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedItems.add(item);
              } else {
                selectedItems.removeWhere((String name) => name == item);
              }
              widget.onSelectionChanged(selectedItems);
            });
          },
          selectedColor: Colors.deepPurple.withOpacity(0.8),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}