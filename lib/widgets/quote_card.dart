import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const QuoteCard({super.key, required this.data});

  // Helper function to format the author and subject line
  String _formatAuthorSubjectLine() {
    final author = data['author'] as Map<String, dynamic>?;
    final faculty = data['faculty'] as String?;
    final subject = data['subject'] as String?;

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

    final facultyText = faculty?.isNotEmpty ?? false
        ? faculty!
        : 'Неизвестный факультет';

    final subjectText = subject?.isNotEmpty ?? false
        ? ' • $subject'
        : '';

    return '$facultyText • $authorName$subjectText';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faculty • Author • Subject
            Text(
              _formatAuthorSubjectLine(),
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Date
            Text(
              data['date'].split('-').reversed.join('.'),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8.0),
            // Quote
            Text(
              data['text'],
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            // Likes and Views
            Row(
              children: [
                Icon(Icons.star, size: 16.0, color: Colors.amber),
                const SizedBox(width: 4.0),
                Text(data['likes'].toString()),
                const SizedBox(width: 16.0),
                Icon(Icons.remove_red_eye, size: 16.0, color: Colors.grey),
                const SizedBox(width: 4.0),
                Text(data['views'].toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}