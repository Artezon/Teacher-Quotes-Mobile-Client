import 'faculty.dart';
import 'subject.dart';
import 'teacher.dart';

class Quote {
  final int id;
  final Faculty faculty;
  final Teacher teacher;
  final Subject subject;
  final String datePublication;
  final String quote;
  final int reactions;
  final int views;
  final bool? isLocked;

  Quote({
    required this.id,
    required this.faculty,
    required this.teacher,
    required this.subject,
    required this.datePublication,
    required this.quote,
    required this.reactions,
    required this.views,
    this.isLocked,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      faculty: Faculty.fromJson(json['faculty']),
      teacher: Teacher.fromJson(json['teacher']),
      subject: Subject.fromJson(json['subject']),
      datePublication: json['datePublication'],
      quote: json['quote'],
      reactions: json['reactions'],
      views: json['views'],
      isLocked: json['isLocked'],
    );
  }
}