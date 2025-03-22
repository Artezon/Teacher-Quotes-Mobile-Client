import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import '../model/quote.dart';
import '../pages/detailed_info.dart';
import '../utils/faculty_formatting.dart';

class QuoteCard extends StatelessWidget {
  final Quote data;
  final bool isDailyQuote;

  const QuoteCard({super.key, required this.data, this.isDailyQuote = false});

  // Helper function to format the author and subject line
  List<String> _formatAuthorSubjectLine() {
    String faculty = data.faculty.name;
    String teacher = data.teacher.fullname;
    String subject = data.subject.name;

    faculty = formatFaculty(faculty);

    List<String> line = [];
    line.add(faculty.isNotEmpty ? faculty : 'Неизвестный факультет');
    line.add(teacher.isNotEmpty ? teacher : 'Аноним');
    if (subject.isNotEmpty) {
      line.add(subject);
    }
    return line;
  }

  void _copyToClipboard() {
    Clipboard.setData(
      ClipboardData(text: '${data.quote}\n\n© ${data.teacher.fullname}'),
    );
    Fluttertoast.showToast(msg: 'Цитата скопирована');
  }

  void _share() {
    Share.share('${data.quote}\n\n© ${data.teacher.fullname}');
  }

  @override
  Widget build(BuildContext context) {
    List<String> topText = _formatAuthorSubjectLine();

    TextStyle topTextStyle = TextStyle(
      color: Colors.grey[700],
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0,
      color:
          isDailyQuote
              ? Color(0xFFCCD3FF)
              : Colors.grey[200],
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Faculty • Author • Subject
                Wrap(
                  children: [
                    GestureDetector(
                      child: Text(
                        topText[0], // Faculty name
                        style: topTextStyle,
                      ),
                      onTap: () {
                        // Navigate to faculty details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailedInfoPage(
                                  contentType: ContentType.faculty,
                                  id: data.faculty.id,
                                ),
                          ),
                        );
                      },
                    ),
                    Text(' • ', style: topTextStyle),
                    GestureDetector(
                      child: Text(
                        topText[1], // Teacher name
                        style: topTextStyle,
                      ),
                      onTap: () {
                        // Navigate to teacher details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DetailedInfoPage(
                                  contentType: ContentType.teacher,
                                  id: data.teacher.id,
                                ),
                          ),
                        );
                      },
                    ),
                    if (topText.length > 2) Text(' • ', style: topTextStyle),
                    if (topText.length > 2)
                      Text(
                        topText[2], // Subject name
                        style: topTextStyle,
                      ),
                    if (isDailyQuote)
                      Text(' • ЦИТАТА ДНЯ!', style: topTextStyle),
                  ],
                ),
                const SizedBox(height: 8.0),
                // Date
                Text(
                  data.datePublication.split('-').reversed.join('.'),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                ),
                const SizedBox(height: 8.0),
                // Quote
                GestureDetector(
                  onLongPress: () {
                    _copyToClipboard();
                    HapticFeedback.vibrate();
                  },
                  child: Text(
                    data.quote,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(height: 8.0),
                // Reactions and views
                Row(
                  children: [
                    Icon(Icons.star, size: 16.0, color: Colors.amber),
                    const SizedBox(width: 4.0),
                    Text(data.reactions.toString()),
                    const SizedBox(width: 16.0),
                    Icon(Icons.remove_red_eye, size: 16.0, color: Colors.grey),
                    const SizedBox(width: 4.0),
                    Text(data.views.toString()),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.copy, size: 16.0, color: Colors.grey),
                  onPressed: _copyToClipboard,
                ),
                IconButton(
                  icon: Icon(Icons.share, size: 16.0, color: Colors.grey),
                  onPressed: _share,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
