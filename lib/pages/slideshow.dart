import 'package:flutter/material.dart';

class ImageSlideshow extends StatelessWidget {
  const ImageSlideshow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: 5, // Number of images in the slideshow
        itemBuilder: (context, index) {
          return Image.network(
            'https://via.placeholder.com/300x200.png?text=Slide+$index', // Placeholder image
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
