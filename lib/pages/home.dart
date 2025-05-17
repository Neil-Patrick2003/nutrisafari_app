import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:test_app/pages/login.dart';
import 'package:test_app/pages/child.dart';
import 'package:test_app/pages/forum.dart';
import 'package:test_app/services/announcement_service.dart';

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
                    horizontal: 20,
                    vertical: 16,
                  ),
                  title: Row(
                    mainAxisAlignment:
                        _scrolled
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NutriSafari",
                        style: TextStyle(
                          color: const Color(0xFF66CA6A),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
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
                            padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImageSlideshow(slides: incomingEvents),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Text(
                    "📢 Announcements",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...announcements.map((announcement) {
                  String formattedDate = 'No date available';
                  if (announcement['created_at'] != null) {
                    try {
                      final dt =
                          DateTime.parse(announcement['created_at']).toLocal();
                      formattedDate = "${dt.day}/${dt.month}/${dt.year}";
                    } catch (_) {}
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Material(
                      color: const Color(0xFFEFFAEF),
                      borderRadius: BorderRadius.circular(14),
                      elevation: 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: Text("📢 ${announcement['title']}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("🗓️ $formattedDate"),
                                      const SizedBox(height: 8),
                                      Text(
                                        announcement['description'] ??
                                            'No content available',
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"),
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
                                "📢 ${announcement['title']}",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF66CA6A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "🗓️ $formattedDate",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                announcement['description'] ??
                                    'No content available',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

// The _ImageSlideshow class can remain mostly the same, with small tweaks for style and padding.

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
                      ? description.substring(0, 100) + "..."
                      : description;

              String startingOnText = "";
              if (slide['start_date'] != null &&
                  slide['start_date'].toString().isNotEmpty) {
                try {
                  DateTime startDate = DateTime.parse(slide['start_date']);
                  startingOnText =
                      "Starting on ${startDate.toLocal().toString().split(' ')[0]}";
                } catch (e) {
                  startingOnText = "";
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 140,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              truncatedDescription,
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (startingOnText.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  startingOnText,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.slides.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentIndex == index
                        ? const Color(0xFF66CA6A)
                        : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
