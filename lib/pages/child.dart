import 'package:flutter/material.dart';
import 'package:test_app/services/child_service.dart';
import 'nutrition_plan.dart';

class ChildPage extends StatefulWidget {
  const ChildPage({super.key});

  @override
  State<ChildPage> createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  late Future<List<Map<String, dynamic>>> _childrenData;

  @override
  void initState() {
    super.initState();
    _childrenData = ChildService.fetchChildrenRecord(); // API call
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _childrenData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No children data available.'));
        }

        final childrenInfoList = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Children Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF66CA6A),
                  ),
                ),
                const SizedBox(height: 16),

                // Display each child's data
                for (int i = 0; i < childrenInfoList.length; i++) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF66CA6A), // Thin green border
                        width: 1.5, // Thin border for each child
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i == 0
                                ? 'First Child Overview'
                                : 'Other Child Overview',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF66CA6A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Indicators',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF66CA6A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._buildIndicators(childrenInfoList[i]),
                        ],
                      ),
                    ),
                  ),
                ],

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NutritionPlanPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66CA6A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "View Nutrition Plan",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildIndicators(Map<String, dynamic> childData) {
    // BMI to category mapping
    String bmiCategory = 'N/A';
    double? bmi = childData['latest_record']?['bmi'];

    if (bmi != null) {
      if (bmi < 18.5) {
        bmiCategory = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        bmiCategory = 'Normal';
      } else if (bmi >= 25) {
        bmiCategory = 'Overweight';
      }
    }

    final indicators = {
      'Name': childData['name'] ?? 'N/A',
      'Age': childData['age']?.toString() ?? 'N/A',
      'BMI': bmi != null ? bmi.toStringAsFixed(2) : 'N/A',
      'BMI Category': bmiCategory,
    };

    return indicators.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              entry.key == 'Name'
                  ? Icons.person
                  : entry.key == 'Age'
                  ? Icons.calendar_today
                  : entry.key == 'BMI'
                  ? Icons.fitness_center
                  : Icons.category,
              color: const Color(0xFF66CA6A),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF66CA6A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(entry.value, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
