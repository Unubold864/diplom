import 'package:flutter/material.dart';

class TouristPlaces extends StatelessWidget {
  const TouristPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Chip(label: Text("random"),
          );
        },
        separatorBuilder:
            (context, index) => Padding(padding: EdgeInsets.only(right: 10)),
        itemCount: 8,
      ),
    );
  }
}
