import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/services/nutrition_controller.dart';

class NutritionPlanPage extends StatefulWidget {
  const NutritionPlanPage({Key? key}) : super(key: key);

  @override
  State<NutritionPlanPage> createState() => _NutritionPlanPageState();
}

class _NutritionPlanPageState extends State<NutritionPlanPage> {
  late Future<List<Map<String, dynamic>>> _plans;

  String getTodayName() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _plans = NutritionService.fetchAllPlans();
  }

  @override
  Widget build(BuildContext context) {
    String today = getTodayName();

    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Plan'),
        backgroundColor: Color(0xFF66CA6A),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _plans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error loading plans: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No plans available."));
          }

          final plans = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              final day = plan['day'] ?? 'Unknown';
              final meals = plan['meals'] ?? []; // Assumes 'meals' is a List

              bool isToday = day == today;

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 3,
                color: isToday ? Color(0xFFd0f0d2) : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                      ...(meals as List<dynamic>).map(
                        (meal) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(meal.toString()),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
