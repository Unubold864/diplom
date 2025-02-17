import 'package:flutter/material.dart';
import 'package:frontend/Components/search_bar_and_filter.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // final CollectionReference categoryCollection =
  //     FirebaseFirestore.instance.collection('places');
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Хайх хэсэг
            SearchBarAndFilter(),
            // StreamBuilder(stream: stream, builder: builder)
          ],
        ),
      ),
    );
  }
}
