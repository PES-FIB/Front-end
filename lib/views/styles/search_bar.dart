import 'package:flutter/material.dart';

TextField searchBar() {
  
  final TextEditingController searchController = TextEditingController();

  return TextField(
    controller: searchController,
    decoration: InputDecoration(
      hintText: 'Search',
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}