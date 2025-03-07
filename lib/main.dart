import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent, // Transparent color
    systemNavigationBarIconBrightness: Brightness.light, // Light icons
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
  // int _counter = 0;
  //
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Цитатник преподавателей КубГУ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.search_rounded),
              title: Text('Поиск'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.article_outlined),
              title: Text('Лента'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.trending_up_rounded),
              title: Text('Топ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_comment_outlined),
              title: Text('Генерация цитаты'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
      // body: Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     //
      //     // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
      //     // action in the IDE, or press "p" in the console), to see the
      //     // wireframe for each widget.
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text('You have pushed the button this many times:'),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      extendBody: true,
    );
  }
}