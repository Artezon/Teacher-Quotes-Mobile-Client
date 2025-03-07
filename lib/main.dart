import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyHomePage(title: 'Лента'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> cardsData = [
    {
      'author': {
        'surname': 'Жук',
        'name': 'Арсений',
        'patronym': 'Сергеевич',
      },
      'faculty': 'ФКТиПМ',
      'subject': 'Теория графов',
      'date': '2023-10-01',
      'text': 'This is some sample text for the first card.',
      'likes': 12,
      'views': 45,
    },
    {
      'author': {
        'surname': 'Иванов',
        'name': 'Иван',
        'patronym': 'Иванович',
      },
      'faculty': '',
      'subject': '', // Subject is null/empty
      'date': '2025-02-14',
      'text': 'This is some sample text for the second card.',
      'likes': 8,
      'views': 32,
    },
    {
      'author': {
        'surname': 'Петров',
        'name': 'Пётр',
      },
      'faculty': 'ФКТиПМ',
      'subject': null, // Subject is null
      'date': '2024-12-03',
      'text': 'This is some sample text for the third card.',
      'likes': 15,
      'views': 67,
    },
  ];

  // Helper function to format the author and subject line
  String _formatAuthorSubjectLine(Map<String, dynamic> card) {
    // Safely extract data with null checks
    final author = card['author'] as Map<String, dynamic>?;
    final faculty = card['faculty'] as String?;
    final subject = card['subject'] as String?;

    // Build author name only if all required fields exist
    String authorName = 'Неизвестный автор';
    if (author != null) {
      final surname = author['surname'] as String? ?? '';
      final name = author['name'] as String? ?? '';
      final patronym = author['patronym'] as String? ?? '';

      if (surname.isNotEmpty && name.isNotEmpty) {
        authorName = '$surname ${name[0]}.';
        if (patronym.isNotEmpty) {
          authorName += ' ${patronym[0]}.';
        }
      }
    }

    // Build faculty text
    final facultyText = faculty?.isNotEmpty ?? false
        ? faculty!
        : 'Неизвестный факультет';

    // Add subject if available
    final subjectText = subject?.isNotEmpty ?? false
        ? ' • $subject'
        : '';

    return '$facultyText • $authorName$subjectText';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () {

            },
            child: Text(
              'Фильтры',
              style: TextStyle(
                color: Theme.of(context).iconTheme.color, // Matches icon color
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: cardsData.length,
        itemBuilder: (context, index) {
          final card = cardsData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2.0, // Subtle shadow
            color: Colors.grey[200], // Gray background
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Faculty • Author • Subject
                  Text(
                    _formatAuthorSubjectLine(card),
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Date (gray)
                  Text(
                    card['date'].split('-').reversed.join('.'),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Text (normal black)
                  Text(
                    card['text'],
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Likes and Views
                  Row(
                    children: [
                      // Likes with star icon
                      Icon(Icons.star, size: 16.0, color: Colors.amber),
                      const SizedBox(width: 4.0),
                      Text(card['likes'].toString()),
                      const SizedBox(width: 16.0),
                      // Views with eye icon
                      Icon(Icons.remove_red_eye, size: 16.0, color: Colors.grey),
                      const SizedBox(width: 4.0),
                      Text(card['views'].toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Лента',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            label: 'Топ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment_outlined),
            label: 'Генерация',
          ),
        ],
        selectedItemColor: Colors.indigo, // Match your theme color
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}