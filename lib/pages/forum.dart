import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isViewingBlogs = true;
  bool _showingMyQuestions = false;

  final List<Map<String, dynamic>> _myQuestions = [
    {
      'title': 'How to boost my toddler’s appetite?',
      'category': 'Nutrition',
      'question': 'My 2-year-old barely eats anything lately, any advice?',
      'replies': [
        {'text': 'Try offering small meals more frequently.', 'role': 'Health Worker'},
      ],
      'newReply': '',
      'isExpanded': false,
    },
  ];

  final List<Map<String, String>> _blogs = [
    {
      'title': 'How can I encourage my child to eat more vegetables?',
      'category': 'Nutrition',
      'image': 'assets/images/vegetables.jpg',
    },
    {
      'title': 'What’s the normal height for a 5-year-old?',
      'category': 'Growth',
      'image': 'assets/images/height.jpg',
    },
    {
      'title': 'Are vitamin supplements necessary for toddlers?',
      'category': 'Health',
      'image': 'assets/images/vitamin.jpg',
    },
    {
      'title': 'How do I manage my child’s screen time?',
      'category': 'Parenting',
      'image': 'assets/images/screentime.jpg',
    },
  ];

  final List<Map<String, dynamic>> _questions = [
    {
      'title': 'What are good snacks for toddlers?',
      'category': 'Nutrition',
      'question': 'I want to give my toddler healthy snacks, any ideas?',
      'replies': [
        {'text': 'Try fruit slices, yogurt, or small cheese cubes.', 'role': 'Health Worker'},
        {'text': 'I give my daughter apple slices with peanut butter.', 'role': 'Parent'},
      ],
      'newReply': '',
      'isExpanded': false,
    },
    {
      'title': 'Is thumb-sucking bad for my child?',
      'category': 'Parenting',
      'question': 'Should I be worried about my child sucking their thumb?',
      'replies': [
        {'text': 'If it continues past age 4-5, it might affect teeth alignment.', 'role': 'Health Worker'},
      ],
      'newReply': '',
      'isExpanded': false,
    },
  ];

  final List<String> _categories = ['All', 'Nutrition', 'Growth', 'Health', 'Parenting'];

  List<Map<String, dynamic>> get _displayedQuestions {
    final source = _showingMyQuestions ? _myQuestions : _questions;
    return source.where((question) {
      final matchesCategory = _selectedCategory == 'All' || question['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          question['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openCreateQuestionDialog() {
    String newQuestion = '';
    String selectedCategoryForNewQuestion = 'Nutrition';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create a New Question'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedCategoryForNewQuestion,
                    onChanged: (newValue) {
                      setModalState(() {
                        selectedCategoryForNewQuestion = newValue!;
                      });
                    },
                    items: _categories
                        .where((c) => c != 'All')
                        .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      newQuestion = value;
                    },
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: 'Enter your question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newQuestion.trim().isNotEmpty) {
                  setState(() {
                    _questions.add({
                      'title': newQuestion.trim(),
                      'category': selectedCategoryForNewQuestion,
                      'question': newQuestion.trim(),
                      'replies': [],
                      'newReply': '',
                      'isExpanded': false,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for keywords',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  selectedColor: Color(0xFF66CA6A),
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isViewingBlogs = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isViewingBlogs ? Color(0xFF66CA6A) : Colors.grey[300],
                    foregroundColor: _isViewingBlogs ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Blogs'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16, top: 12, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isViewingBlogs = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isViewingBlogs ? Color(0xFF66CA6A) : Colors.grey[300],
                    foregroundColor: !_isViewingBlogs ? Colors.white : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Questions'),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _isViewingBlogs ? _blogs.length : _displayedQuestions.length,
            itemBuilder: (context, index) {
              if (_isViewingBlogs) {
                final blog = _blogs[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        blog['image']!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(blog['title']!, style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                );
              } else {
                final question = _displayedQuestions[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(question['title']),
                    subtitle: Text(question['category'], style: TextStyle(color: Colors.grey)),
                    initiallyExpanded: question['isExpanded'],
                    onExpansionChanged: (expanded) {
                      setState(() {
                        question['isExpanded'] = expanded;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Text('Question: ${question['question']}'),
                      ),
                      if (question['replies'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: question['replies']
                                .map<Widget>((reply) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '${reply['role']}: ${reply['text']}',
                                style: TextStyle(
                                  fontStyle: reply['role'] == 'Health Worker'
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                            ))
                                .toList(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    question['newReply'] = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Write a reply...',
                                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if ((question['newReply'] ?? '').trim().isNotEmpty) {
                                  setState(() {
                                    question['replies'].add({
                                      'text': question['newReply'].trim(),
                                      'role': 'Parent',
                                    });
                                    question['newReply'] = '';
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF66CA6A),
                              ),
                              child: Text('Send'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        if (!_isViewingBlogs)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _openCreateQuestionDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF66CA6A),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Ask a Question'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showingMyQuestions = !_showingMyQuestions;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showingMyQuestions ? Color(0xFF66CA6A) : Colors.grey[300],
                      foregroundColor: _showingMyQuestions ? Colors.white : Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_showingMyQuestions ? 'All Questions' : 'My Questions'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
