import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mq_mobile_quotes/model/generated_quote.dart';
import '../model/filter_state.dart';
import '../widgets/generation_card.dart';

class QuoteGeneratorPage extends StatefulWidget {
  const QuoteGeneratorPage({super.key});

  static const List<String> generationTopics = [
    'Тема 1',
    'Тема 2',
    'Тема 3',
    'Тема 4',
    'Тема 5',
  ];

  @override
  State<QuoteGeneratorPage> createState() => _QuoteGeneratorPageState();
}

class _QuoteGeneratorPageState extends State<QuoteGeneratorPage> {
  // Dropdown values
  String? _selectedTeacher;
  String? _selectedTopic;

  int _lastQuoteNumber = 0;

  static final List<GeneratedQuote> _generations = [];

  bool _areTeachersLoaded = false;
  Future<Map<String, int>>? _teachersFuture;

  void _generateQuote() {
    if (_selectedTeacher == null || _selectedTopic == null) {
      Fluttertoast.showToast(msg: 'Выберите преподавателя и тему');
      return;
    }

    // Simulate generating a quote (use "Lorem Ipsum" for now)
    setState(() {
      _generations.insert(0, GeneratedQuote(quote: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', teacher: _selectedTeacher ?? 'N/A', topic: _selectedTopic ?? 'N/A', number: ++_lastQuoteNumber));
    });
  }

  void _removeQuote(int number) {
    setState(() {
      _generations.removeWhere((quote) => quote.number == number);
    });
  }

  @override
  void initState() {
    super.initState();

    _teachersFuture = FilterState.allTeachers != null
        ? Future.value(FilterState.allTeachers)
        : FilterState.fetchAllTeachers();
    _teachersFuture!.then((teachers) {
      setState(() {
        _areTeachersLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Генератор цитат'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher Dropdown
            FutureBuilder<Map<String, int>?>(
              future: _teachersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Загрузка...',
                    ),
                    items: [],
                    onChanged: null,
                  );
                } else if (snapshot.hasError) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Ошибка загрузки',
                    ),
                    items: [],
                    onChanged: null,
                  );
                } else {
                  final teachers = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _selectedTeacher,
                    decoration: InputDecoration(labelText: 'Выберите преподавателя'),
                    items: teachers.keys.toList().sublist(1).map((teacherName) {
                      return DropdownMenuItem(
                        value: teacherName,
                        child: Text(teacherName),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedTeacher = value),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // Topic Dropdown
            DropdownButtonFormField<String>(
              value: _selectedTopic,
              decoration: InputDecoration(labelText: 'Выберите тему'),
              items: QuoteGeneratorPage.generationTopics.map((topic) {
                return DropdownMenuItem(value: topic, child: Text(topic));
              }).toList(),
              onChanged: (value) => setState(() => _selectedTopic = value),
            ),

            const SizedBox(height: 16),

            // Generate Quote Button (centered and disabled until teachers are loaded)
            Center(
              child: ElevatedButton(
                onPressed: _areTeachersLoaded ? _generateQuote : null,
                child: Text('Сгенерировать цитату'),
              ),
            ),

            const SizedBox(height: 16),

            // Generated Quotes List
            Column(
              children: _generations.map((quote) {
                return GenerationCard(
                  generatedQuote: quote.quote,
                  teacher: quote.teacher,
                  topic: quote.topic,
                  onRemove: () => _removeQuote(quote.number),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}