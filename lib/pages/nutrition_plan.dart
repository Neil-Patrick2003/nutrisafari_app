import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:test_app/services/nutrition_controller.dart'; // For rendering HTML if needed

class NutritionPlanPage extends StatefulWidget {
  const NutritionPlanPage({Key? key}) : super(key: key);

  @override
  State<NutritionPlanPage> createState() => _NutritionPlanPageState();
}

class _NutritionPlanPageState extends State<NutritionPlanPage> {
  late Future<List<Map<String, dynamic>>> _plans;

  @override
  void initState() {
    super.initState();
    _plans = NutritionService.fetchAllPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Plans'),
        backgroundColor: Color(0xFF66CA6A),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _plans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No nutrition plans available."));
          }

          final plans = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // Show dialog with full description
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("📋 ${plan['title']}"),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "🎯 Goal: ${plan['goal_type'] ?? 'N/A'}",
                                  ),
                                  SizedBox(height: 8),
                                  Html(
                                    data:
                                        plan['description'] ?? "No description",
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Close"),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan['title'] ?? "Untitled",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF66CA6A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Goal: ${plan['goal_type'] ?? 'N/A'}"),
                        SizedBox(height: 8),
                        Html(
                          data: plan['description'] ?? '',
                          style: {
                            "body": Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                          },
                        ),
                      ],
                    ),
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
