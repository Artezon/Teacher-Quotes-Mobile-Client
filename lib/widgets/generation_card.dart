import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class GenerationCard extends StatelessWidget {
  final String generatedQuote;
  final String teacher;
  final String topic;
  final VoidCallback onRemove;

  static const disclaimer =
      '\n--------------------\nСодержимое сгенерировано ИИ и не является реальной цитатой.';

  const GenerationCard({
    super.key,
    required this.generatedQuote,
    required this.teacher,
    required this.topic,
    required this.onRemove,
  });

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: '$generatedQuote$disclaimer'));
    Fluttertoast.showToast(msg: 'Цитата скопирована в буфер обмена');
  }

  void _shareQuote() {
    Share.share('$generatedQuote$disclaimer');
  }

  @override
  Widget build(BuildContext context) {
    TextStyle topTextStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0,
      color: Colors.grey[200],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$teacher • $topic • Сгенерировано ИИ',
                    style: topTextStyle,
                  ),
                  Text(generatedQuote, style: const TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border(
                            right: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        height: 50,
                        child: Center(
                          child: Text('Убрать', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _copyToClipboard,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border(
                            right: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        height: 50,
                        child: Center(
                          child: Text(
                            'Копировать',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _shareQuote,
                      child: Container(
                        color: Colors.grey[300],
                        height: 50,
                        child: Center(
                          child: Text(
                            'Поделиться',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
