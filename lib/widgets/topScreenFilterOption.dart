import 'package:flutter/material.dart';

Widget topScreenFilterOption({
  text,
  id,
  currentOptionId,
  handleFilterOptionsChange,
}) {
  return GestureDetector(
    onTap: () => handleFilterOptionsChange(text, id),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Colors.cyan, width: 0.5),
        color: id == currentOptionId ? Colors.cyan : Colors.white,
      ),
      constraints: const BoxConstraints(
        minWidth: 10.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 3.0,
        vertical: 3.0,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: id == currentOptionId ? Colors.white : Colors.cyan,
            fontSize: 14.0,
          ),
        ),
      ),
    ),
  );
}
