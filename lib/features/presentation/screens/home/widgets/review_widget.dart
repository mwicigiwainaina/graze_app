import 'package:flutter/material.dart';
import 'package:graze_app/core/constants/constants.dart';

class FoodReviewWidget extends StatelessWidget {
  final String dishName;
  final String distance;
  final String restaurant;
  final String rating;
  final String description;

  const FoodReviewWidget({
    required this.dishName,
    required this.distance,
    required this.restaurant,
    required this.rating,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(0.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                restaurant,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0,
                ),
              ),
              Text(
                '$distance mi away',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dishName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 4.0),
                  Text(
                    '$rating/10',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            '$description',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Chip(
                  label: Text(
                    '\$\$',
                    style: TextStyle(
                      color: grazeGreenText,
                    ),
                  ),
                  backgroundColor: grazeGreen,
                ),
                SizedBox(width: 8.0),
                Chip(
                  label: Text(
                    'Dinner',
                    style: TextStyle(
                      color: grazeGreenText,
                    ),
                  ),
                  backgroundColor: grazeGreen,
                ),
                SizedBox(width: 8.0),
                Chip(
                  label: Text(
                    'Great service',
                    style: TextStyle(
                      color: grazeGreenText,
                    ),
                  ),
                  backgroundColor: grazeGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}