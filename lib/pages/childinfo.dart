import 'package:flutter/material.dart';

class ChildInfoPage extends StatelessWidget {
  final Map<String, String> childInfo;

  const ChildInfoPage({super.key, required this.childInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: childInfo.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
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
        );
      }).toList(),
    );
  }
}
