import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:frontend/widgets/location_card.dart';
import 'package:frontend/widgets/tourist_places.dart';
import 'package:ionicons_named/ionicons_named.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Өглөөний мэнд"),
            Text(
              "Батаа",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        actions: [
          CustomIconButton(icon: Icon(ionicons['search_outline'])),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 12),
            child: CustomIconButton(
              icon: Icon(ionicons['notifications_outline']),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(14),
        children: [
          // Байршил болон хайлт хэсэг
          LocationCard(),
          SizedBox(height: 15),
          TouristPlaces(),
          // Төрөл болон бусад хэсэг
          // Зөвлөгөө хэсэг
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(ionicons['home_outline']),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(ionicons['bookmark_outline']),
            label: "Bookmark",
          ),
          BottomNavigationBarItem(
            icon: Icon(ionicons['heart_outline']),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(ionicons['person_outline']),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
