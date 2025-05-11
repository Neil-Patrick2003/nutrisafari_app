import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:test_app/pages/login.dart';
import 'package:test_app/pages/child.dart';  // Import child.dart
import 'package:test_app/pages/forum.dart';  // Import forum.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scrolled = false;
  int _selectedIndex = 0;

  // List of pages for the bottom navigation
  final List<Widget> _pages = [
    HomePageContent(),  // Home page
    ChildPage(),        // Child page placeholder
    ForumPage(),        // Forum page placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.axis == Axis.vertical) {
            bool isScrolled = scrollNotification.metrics.pixels > 0;
            if (_scrolled != isScrolled) {
              setState(() {
                _scrolled = isScrolled;
              });
            }
          }
          return false;
        },
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: 100,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: _scrolled,
                  titlePadding: EdgeInsets.only(
                      left:  16,
                      right: 16,
                      bottom: 16),
                  title: Row(
                    mainAxisAlignment: _scrolled
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NutriSafari",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (!_scrolled)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to LoginPage
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/logout.svg',
                            width: 24,
                            height: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: _pages[_selectedIndex], // Display the selected page
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected page
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            label: 'Child',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
        ],
      ),
    );
  }
}

// Home Page Content
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // ✅ Makes everything scrollable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            color: Color(0xFF66CA6A),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'WELCOME Gian Patrick Victoriano!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Latest News',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          // Slideshow box
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: _ImageSlideshow(),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Announcements',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          // ➕ Current Event Overview Section
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFEFFAEF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF66CA6A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Event Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF66CA6A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "📅 Feeding Program - July 25, 2025\n🕘 9:00 AM - 12:00 PM\n📍 Barangay Hall, Main Hall",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFFEFFAEF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFF66CA6A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Event Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF66CA6A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "📅 Feeding Program - July 25, 2025\n🕘 9:00 AM - 12:00 PM\n📍 Barangay Hall, Main Hall",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Slideshow Widget
class _ImageSlideshow extends StatefulWidget {
  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<_ImageSlideshow> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/healthy.jpeg',
      'description': 'Healthy eating is key to strong immunity and growth!',
    },
    {
      'image': 'assets/images/kids.jpg',
      'description': 'Fruits are rich in vitamins and keep you energized!',
    },
    {
      'image': 'assets/images/ice.jpg',
      'description': 'Vegetables provide fiber for healthy digestion.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        int nextPage = (_currentIndex + 1) % _slides.length;
        _controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Slideshow
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(
                    _slides[index]['image']!,
                    width: 150,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _slides[index]['description']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
        ),

        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
                (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color(0xFF66CA6A)
                    : Colors.grey,
              ),
            ),
          ),
        ),

        // Read More button
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF66CA6A),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Read More",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

