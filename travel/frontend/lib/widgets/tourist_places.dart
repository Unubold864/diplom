import 'package:flutter/material.dart';
import 'package:frontend/models/tourist_places_model.dart';

class TouristPlaces extends StatelessWidget {
  const TouristPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle tap event
                print('Selected: ${touristPlaces[index].name}');
              },
              child: Chip(
                label: Text(
                  touristPlaces[index].name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                avatar: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(touristPlaces[index].image),
                ),
                backgroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => 
            const SizedBox(width: 12),
        itemCount: touristPlaces.length,
      ),
    );
  }
}
