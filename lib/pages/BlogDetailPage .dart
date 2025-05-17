import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  final Map<String, dynamic> blog;

  BlogDetailPage({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(blog['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(blog['image_url']),
            SizedBox(height: 16),
            Text(
              blog['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Detailed blog content goes here.'),
            // Add any other blog content you'd like to show here.
          ],
        ),
      ),
    );
  }
}
