import 'package:flutter/material.dart';

void main() {
  runApp(const SimpleBlogApp());
}

class SimpleBlogApp extends StatelessWidget {
  const SimpleBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Blog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> posts = [
    {
      'title': 'Getting Started with Flutter',
      'author': 'Karl',
      'content':
          'Flutter is a framework developed by Google. '
          'It allows developers to build mobile, web and desktop applications.',
    },
  
  ];

  // Open the screen for writing a post
  void addPost() async {
    final newPost = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );

    if (newPost != null) {
      setState(() {
        posts.insert(0, newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simple Blog',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addPost,
        icon: const Icon(Icons.edit),
        label: const Text('Write Post'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Latest Blog Posts',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          if (posts.isEmpty) const Center(child: Text('No blog posts yet.')),

          ...posts.map((post) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  post['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'By ${post['author']}\n\n${post['content']}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailsScreen(post: post),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

// CREATE BLOG POST SCREEN
class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final contentController = TextEditingController();

  void publishPost() {
    if (titleController.text.trim().isEmpty ||
        authorController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    Navigator.pop(context, {
      'title': titleController.text.trim(),
      'author': authorController.text.trim(),
      'content': contentController.text.trim(),
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Blog Post'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Post',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Blog Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Write your blog here...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: publishPost,
                icon: const Icon(Icons.publish),
                label: const Text('Publish Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// READ BLOG POST SCREEN
class PostDetailsScreen extends StatelessWidget {
  final Map<String, String> post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title']!,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              'Written by ${post['author']}',
              style: const TextStyle(color: Colors.grey),
            ),

            const Divider(height: 30),

            Text(
              post['content']!,
              style: const TextStyle(fontSize: 17, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
