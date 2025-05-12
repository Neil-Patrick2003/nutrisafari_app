import 'package:flutter/material.dart';
import 'package:test_app/services/blog_service.dart';
import 'package:test_app/services/forum_service.dart';
import 'package:test_app/services/post_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

File? _selectedFile;

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final _TopicController = TextEditingController();
  final _TitleController = TextEditingController();
  final _BodyController = TextEditingController();

  final _replyController = TextEditingController();
  String _searchQuery = '';
  bool _isViewingBlogs = true;
  bool _showingMyQuestions = false;

  File? _selectedImage;

  List<Map<String, dynamic>> _myQuestions = [];
  List<Map<String, dynamic>> _blogs = [];
  final Map<int, TextEditingController> _replyControllers = {};

  @override
  void initState() {
    super.initState();
    _loadBlogs();
    _loadForums();
  }

  @override
  void dispose() {
    // Dispose of all controllers when the page is disposed
    _replyControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  // Asynchronous method to load forum data
  Future<void> _loadForums() async {
    try {
      List<Map<String, dynamic>> forums = await ForumService.fetchAllForums();
      setState(() {
        _myQuestions = forums;
      });
    } catch (e) {
      // Handle any errors here (e.g., show a snackbar or alert)
      print('Error: $e');
    }
  }

  Future<void> _loadBlogs() async {
    try {
      List<Map<String, dynamic>> blogs = await BlogService.fetchBlogs();
      setState(() {
        _blogs = blogs;
      });
    } catch (e) {
      // Handle any errors here (e.g., show a snackbar or alert)
      print('Error: $e');
    }
  }

  void _openCreateBlog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.all(16),
          title: Row(
            children: [
              Icon(Icons.question_answer, color: Colors.green, size: 24),
              SizedBox(width: 12),
              Text(
                'Create a New Blog',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your blog content:',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _TitleController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Type your blog...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _BodyController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Type your blog...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Show bottom sheet with options to pick file or take a photo
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text("Pick from Gallery"),
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(
                                        withData: false,
                                        type: FileType.image,
                                        allowMultiple: false,
                                      );

                                  if (result != null &&
                                      result.files.single.path != null) {
                                    setState(() {
                                      _selectedImage = File(
                                        result.files.single.path!,
                                      );
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text("Open Camera"),
                                onTap: () async {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                    source:
                                        ImageSource
                                            .camera, // Explicitly set camera source
                                    maxWidth: 600,
                                  );

                                  if (pickedFile != null) {
                                    setModalState(() {
                                      _selectedFile = File(pickedFile.path);
                                    });
                                  }

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.image, color: Colors.white),
                    label: Text(
                      'Select Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  if (_selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.file(
                        _selectedFile!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              );
            },
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            ElevatedButton(
              onPressed: () {
                String blogTitle = _TitleController.text.trim();
                String blogBody = _BodyController.text.trim();

                if (blogTitle.isNotEmpty &&
                    blogBody.isNotEmpty &&
                    _selectedImage != null) {
                  print('Blog: $blogTitle ');
                  print('Blog: $blogBody ');

                  print('Image: ${_selectedFile?.path}');

                  // TODO: Call your blog creation API/service here with _selectedFile and newQuestion

                  BlogService.createBlog(blogTitle, blogBody, _selectedImage!);

                  _TopicController.clear();
                  _selectedFile = null;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('New blog posted!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openCreateQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16,
            ), // Rounded corners for the dialog
          ),
          backgroundColor: Colors.white, // White background for the dialog
          titlePadding: EdgeInsets.all(16), // Padding for the title
          title: Row(
            children: [
              Icon(
                Icons.question_answer, // Choose the appropriate icon
                color: Colors.green, // Set the icon color to green
                size: 24, // Adjust the icon size
              ),
              SizedBox(width: 12), // Add space between the icon and the text
              Text(
                'Create a New Question',
                style: TextStyle(
                  fontSize: 16, // Larger font size for the title
                  fontWeight: FontWeight.bold, // Make the title bold
                  color: Colors.green, // Set the text color to green
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ), // Padding around the content
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align content to the left
                children: [
                  Text(
                    'Enter your question below:',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          Colors.black87, // Darker text color for readability
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ), // Space between the label and the text field
                  TextField(
                    controller: _TopicController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Type your question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ), // Rounded corners for the text field
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 2,
                        ), // Green focus border
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ), // Padding for the buttons
          actions: [
            ElevatedButton(
              onPressed: () {
                String newQuestion = _TopicController.text.trim();

                if (newQuestion.isNotEmpty) {
                  print(newQuestion);
                  ForumService.createForum(newQuestion);
                  _loadForums();

                  // Display confirmation message at the top of the screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('New question posted!'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                _TopicController.clear();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Use backgroundColor instead of primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    8,
                  ), // Rounded corners for the button
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white, // White text for the button
                  fontSize: 16,
                ),
              ),
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
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: TextField(
        //     decoration: InputDecoration(
        //       hintText: 'Search for keywords',
        //       prefixIcon: Icon(Icons.search),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       filled: true,
        //       fillColor: Colors.grey[100],
        //     ),
        //     onChanged: (value) {
        //       setState(() {
        //         _searchQuery = value;
        //       });
        //     },
        //   ),
        // ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isViewingBlogs = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isViewingBlogs ? Color(0xFF66CA6A) : Colors.grey[300],
                    foregroundColor:
                        _isViewingBlogs ? Colors.white : Colors.black,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isViewingBlogs = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !_isViewingBlogs ? Color(0xFF66CA6A) : Colors.grey[300],
                    foregroundColor:
                        !_isViewingBlogs ? Colors.white : Colors.black,
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
        if (!_isViewingBlogs)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _openCreateQuestionDialog,
                child: Text('Ask a Question'),
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _isViewingBlogs ? _blogs.length : _myQuestions.length,
            itemBuilder: (context, index) {
              if (_isViewingBlogs) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _openCreateBlog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(Icons.create),
                        label: Text(
                          'Create New Blog',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            "https://nutrisafari.xyz/storage/${_blogs[index]['image_url']!}",
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _blogs[index]['title']!,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                final question = _myQuestions[index];

                if (!_replyControllers.containsKey(index)) {
                  _replyControllers[index] = TextEditingController();
                }
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      question['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    initiallyExpanded: false,
                    children: [
                      if (question['posts_count'] > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                question['posts'].map<Widget>((reply) {
                                  bool isCurrentUser =
                                      reply['user']['is_me'] ?? false;

                                  return Align(
                                    alignment:
                                        isCurrentUser
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            isCurrentUser
                                                ? Colors.blue[50]
                                                : Colors.green[50],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                          bottomLeft:
                                              isCurrentUser
                                                  ? Radius.circular(12)
                                                  : Radius.circular(0),
                                          bottomRight:
                                              isCurrentUser
                                                  ? Radius.circular(0)
                                                  : Radius.circular(12),
                                        ),
                                        border: Border.all(
                                          color:
                                              isCurrentUser
                                                  ? Colors.blue.shade300
                                                  : Colors.green.shade300,
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${reply['user']['name']}: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isCurrentUser
                                                        ? Colors.blue[800]
                                                        : Colors.green[800],
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: reply['body'],
                                              style: TextStyle(
                                                color:
                                                    isCurrentUser
                                                        ? Colors.blue[900]
                                                        : Colors.green[900],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: TextField(
                          controller: _replyControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Add a reply',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              String replyText =
                                  _replyControllers[index]!.text.trim();
                              if (replyText.isNotEmpty) {
                                PostService.createForum(
                                  replyText,
                                  question['id'],
                                );
                                _loadForums();
                                _replyControllers[index]!.clear();
                              }
                            },
                            icon: Icon(Icons.send),
                            label: Text('Submit Reply'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
