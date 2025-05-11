import 'package:flutter/material.dart';
import 'childinfo.dart'; // Import the new blueprint
import 'nutrition_plan.dart';

class ChildPage extends StatelessWidget {
  final Map<String, String> childInfo = {
    'Name': 'Gian Patrick Victoriano',
    'Age': '5 years old',
    'Height': '110 cm',
    'Weight': '18 kg',
    'Gender': 'Male',
    'Blood Type': 'O+',
    'Birthdate': 'March 10, 2020',
  };

  final Map<String, String> indicators = {
    'BMI': '15.2 (Normal)',
    'Development Status': 'On Track',
  };

  final Map<String, String> secondChildInfo = {
    'Name': 'Lucas Maria Santos',
    'Age': '4 years old',
    'Height': '105 cm',
    'Weight': '16 kg',
    'Gender': 'Female',
    'Blood Type': 'A+',
    'Birthdate': 'June 15, 2021',
  };

  final Map<String, String> secondIndicators = {
    'BMI': '14.9 (Normal)',
    'Development Status': 'On Track',
  };

  ChildPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Child Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66CA6A),
              ),
            ),
            SizedBox(height: 16),
            // Use ChildInfoPage for the first child
            ChildInfoPage(childInfo: childInfo),

            SizedBox(height: 24),
            Text(
              'Indicators',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66CA6A),
              ),
            ),
            SizedBox(height: 12),
            // Display the indicators for the first child
            ...indicators.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${entry.key}:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )),

            SizedBox(height: 32),
            // Add another child info and indicators for the second child
            Text(
              'Other Child Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66CA6A),
              ),
            ),
            SizedBox(height: 16),
            ChildInfoPage(childInfo: secondChildInfo),

            SizedBox(height: 24),
            Text(
              'Indicators',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF66CA6A),
              ),
            ),
            SizedBox(height: 12),
            ...secondIndicators.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${entry.key}:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )),

            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NutritionPlanPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF66CA6A),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "View Nutrition Plan",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
