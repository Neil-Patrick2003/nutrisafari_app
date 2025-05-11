import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl package to pubspec.yaml if not already

class NutritionPlanPage extends StatelessWidget {
  final Map<String, List<String>> mealPlan = {
    'Monday': ['Breakfast: Oatmeal with banana', 'Lunch: Chicken and rice', 'Dinner: Veggie soup'],
    'Tuesday': ['Breakfast: Scrambled eggs and toast', 'Lunch: Fish with sweet potatoes', 'Dinner: Pasta with tomato sauce'],
    'Wednesday': ['Breakfast: Yogurt with fruits', 'Lunch: Beef stew and veggies', 'Dinner: Rice and steamed broccoli'],
    'Thursday': ['Breakfast: Pancakes with berries', 'Lunch: Grilled chicken sandwich', 'Dinner: Vegetable stir-fry'],
    'Friday': ['Breakfast: Cereal with milk', 'Lunch: Tuna salad wrap', 'Dinner: Baked salmon with quinoa'],
  };

  NutritionPlanPage({super.key});

  String getTodayName() {
    return DateFormat('EEEE').format(DateTime.now()); // Returns full day name like 'Monday'
  }

  @override
  Widget build(BuildContext context) {
    String today = getTodayName();

    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Plan'),
        backgroundColor: Color(0xFF66CA6A),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: mealPlan.keys.length,
        itemBuilder: (context, index) {
          String day = mealPlan.keys.elementAt(index);
          List<String> meals = mealPlan[day]!;

          bool isToday = day == today;

          return Card(
            margin: EdgeInsets.only(bottom: 12),
            elevation: 3,
            color: isToday ? Color(0xFFd0f0d2) : null, // Highlight today
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF66CA6A),
                    ),
                  ),
                  SizedBox(height: 8),
                  ...meals.map((meal) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(meal),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
