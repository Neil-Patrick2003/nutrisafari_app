import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:test_app/pages/login.dart';
import 'package:test_app/pages/child.dart';
import 'package:test_app/pages/forum.dart';
import 'package:test_app/services/announcement_service.dart';
import 'package:flutter_html/flutter_html.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _scrolled = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const ChildPage(),
    const ForumPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.axis == Axis.vertical) {
            bool isScrolled = scrollNotification.metrics.pixels > 0;
            if (_scrolled != isScrolled) {
              setState(() => _scrolled = isScrolled);
            }
          }
          return false;
        },
        child: NestedScrollView(
          headerSliverBuilder: (_, __) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: 100,
                elevation: 2,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: _scrolled,
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  title: Row(
                    mainAxisAlignment:
                        _scrolled
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "NutriSafari",
                        style: TextStyle(
                          color: const Color(0xFF66CA6A),
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black12,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      if (!_scrolled)
                        InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/icons/logout.svg',
                              width: 28,
                              height: 28,
                              color: Colors.redAccent,
                              semanticsLabel: 'Logout',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF66CA6A),
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.child_care), label: 'Child'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forum'),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  late Future<Map<String, List<Map<String, dynamic>>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = AnnouncementService.fetchAnnouncementData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }

        final announcements = snapshot.data?["announcements"] ?? [];
        final incomingEvents = snapshot.data?["incoming_events"] ?? [];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImageSlideshow(slides: incomingEvents),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    "📢 Announcements",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Simple stack card list for announcements
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: announcements.length * 120.0,
                    child: Stack(
                      children:
                          announcements.asMap().entries.map((entry) {
                            int index = entry.key;
                            var announcement = entry.value;

                            String formattedDate = 'No date available';
                            if (announcement['created_at'] != null) {
                              try {
                                final dt =
                                    DateTime.parse(
                                      announcement['created_at'],
                                    ).toLocal();
                                formattedDate =
                                    "${dt.day}/${dt.month}/${dt.year}";
                              } catch (_) {}
                            }

                            return Positioned(
                              top:
                                  index *
                                  140.0, // 130 instead of 110 adds 20px extra space
                              left: 0,
                              right: 0,
                              child: Material(
                                color: const Color(0xFFEFFAEF),
                                borderRadius: BorderRadius.circular(16),
                                elevation: 1.5,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: Text(
                                              "📢 ${announcement['title']}",
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("🗓️ $formattedDate"),
                                                const SizedBox(height: 10),
                                                Html(
                                                  data:
                                                      announcement['description'] ??
                                                      'No content available',
                                                  style: {
                                                    "body": Style(
                                                      fontSize: FontSize(14),
                                                      color: Colors.black,
                                                    ),
                                                  },
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text("Close"),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                      horizontal: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "📢 ${announcement['title']}",
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: const Color(0xFF66CA6A),
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "🗓️ $formattedDate",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Colors.grey[700],
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        Html(
                                          data:
                                              announcement['description'] ??
                                              'No content available',
                                          style: {
                                            "body": Style(
                                              fontSize: FontSize(14),
                                              color: Colors.black,
                                            ),
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ImageSlideshow extends StatefulWidget {
  final List<Map<String, dynamic>> slides;
  const _ImageSlideshow({required this.slides});

  @override
  State<_ImageSlideshow> createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<_ImageSlideshow> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.slides.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (_controller.hasClients) {
          int next = (_currentIndex + 1) % widget.slides.length;
          _controller.animateToPage(
            next,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.slides.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, index) {
              final slide = widget.slides[index];
              final imageUrl =
                  "https://nutrisafari.xyz/storage/${slide['program_background_url']}";

              String description = slide['description'] ?? "";
              String truncatedDescription =
                  description.length > 100
                      ? "${description.substring(0, 100)}..."
                      : description;

              String startingOnText = "";
              if (slide['start_date'] != null) {
                try {
                  final dt = DateTime.parse(slide['start_date']).toLocal();
                  startingOnText =
                      "Starting on: ${dt.day}/${dt.month}/${dt.year}";
                } catch (_) {}
              }

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 6),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 80),
                          ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slide['program_title'] ?? 'Untitled',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(blurRadius: 4, color: Colors.black),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            truncatedDescription,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (startingOnText.isNotEmpty)
                            Text(
                              startingOnText,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.lightGreenAccent,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.slides.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentIndex == index
                        ? Colors.green[600]
                        : Colors.grey[400],
              ),
            );
          }),
        ),
      ],
    );
  }
}
