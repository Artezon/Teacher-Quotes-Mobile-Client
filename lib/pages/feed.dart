import 'package:flutter/material.dart';
import '../widgets/quote_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String title = 'Лента';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
        itemBuilder: (context, index) => QuoteCard(data: cardsData[index]),
      ),
    );
  }
}