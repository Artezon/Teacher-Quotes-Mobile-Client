import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../api_data.dart';
import '../model/generated_quote.dart';
import '../widgets/generation_card.dart';

class QuoteGeneratorPage extends StatefulWidget {
  const QuoteGeneratorPage({super.key});

  static const Map<String, String> generationTopics = {
    'Лекция': 'lecture',
    'Экзамен': 'exam',
    'Курсовая работа': 'coursework',
    'Студенческая жизнь': 'student_life',
    'Мотивация': 'motivation',
  };

  @override
  State<QuoteGeneratorPage> createState() => _QuoteGeneratorPageState();
}

class _QuoteGeneratorPageState extends State<QuoteGeneratorPage> {
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final FocusNode _teacherFocusNode = FocusNode();
  final FocusNode _topicFocusNode = FocusNode();
  final GlobalKey _teacherFieldKey = GlobalKey();
  final GlobalKey _topicFieldKey = GlobalKey();
  String? _selectedTeacher;
  int? _selectedTeacherId;
  String? _selectedTopic;
  int _lastQuoteNumber = 0;
  static final List<GeneratedQuote> _generations = [];
  Timer? _debounce;
  List<Map<String, dynamic>> _teacherResults = [];
  bool _isLoadingTeachers = false;
  bool _isGenerating = false;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _topicOverlayEntry;

  @override
  void initState() {
    super.initState();
    _teacherController.addListener(_onTeacherSearchChanged);
    _teacherFocusNode.addListener(_handleTeacherFocusChange);
    _topicFocusNode.addListener(_handleTopicFocusChange);
  }

  @override
  void dispose() {
    _teacherController.removeListener(_onTeacherSearchChanged);
    _teacherController.dispose();
    _teacherFocusNode.removeListener(_handleTeacherFocusChange);
    _teacherFocusNode.dispose();
    _topicFocusNode.removeListener(_handleTopicFocusChange);
    _topicFocusNode.dispose();
    _debounce?.cancel();
    _overlayEntry?.remove();
    _topicOverlayEntry?.remove();
    super.dispose();
  }

  void _handleTeacherFocusChange() {
    if (!_teacherFocusNode.hasFocus) {
      _hideTeacherOverlay();
    }
  }

  void _handleTopicFocusChange() {
    if (!_topicFocusNode.hasFocus) {
      _hideTopicOverlay();
    }
  }

  void _onTeacherSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchTeachers(_teacherController.text);
    });
  }

  Future<void> _searchTeachers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _teacherResults = [];
      });
      _hideTeacherOverlay();
      return;
    }

    setState(() {
      _isLoadingTeachers = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$getTeachers?name=$query&size=50'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _teacherResults = List<Map<String, dynamic>>.from(data['teachers']);
          _isLoadingTeachers = false;
        });
        if (_teacherFocusNode.hasFocus) {
          _showTeacherOverlay();
        }
      } else {
        throw Exception('Failed to load teachers');
      }
    } catch (e) {
      setState(() {
        _isLoadingTeachers = false;
      });
      Fluttertoast.showToast(msg: 'Ошибка загрузки преподавателей: $e');
      _hideTeacherOverlay();
    }
  }

  void _showTeacherOverlay() {
    _hideTeacherOverlay(); // Remove any existing overlay

    final RenderBox? renderBox =
        _teacherFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Invisible layer to capture taps outside
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideTeacherOverlay,
                  behavior: HitTestBehavior.opaque,
                ),
              ),
              Positioned(
                left: position.dx,
                top: position.dy + size.height + 2,
                // Small offset to avoid overlap
                width: size.width,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child:
                        _isLoadingTeachers
                            ? const Center(child: CircularProgressIndicator())
                            : _teacherResults.isEmpty
                            ? Container()
                            : ListView.builder(
                              padding:
                                  EdgeInsets.zero, // Remove default padding
                              shrinkWrap: true,
                              itemCount: _teacherResults.length,
                              itemBuilder: (context, index) {
                                final teacher = _teacherResults[index];
                                return ListTile(
                                  title: Text(teacher['fullname']),
                                  onTap: () {
                                    setState(() {
                                      _selectedTeacher = teacher['fullname'];
                                      _selectedTeacherId = teacher['id'];
                                      _teacherController.text =
                                          teacher['fullname'];
                                      _teacherResults = [];
                                    });
                                    _teacherFocusNode.unfocus();
                                    _hideTeacherOverlay();
                                  },
                                );
                              },
                            ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTeacherOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showTopicOverlay() {
    _hideTopicOverlay(); // Remove any existing overlay

    final RenderBox? renderBox =
        _topicFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _topicOverlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Invisible layer to capture taps outside
              Positioned.fill(
                child: GestureDetector(
                  onTap: _hideTopicOverlay,
                  behavior: HitTestBehavior.opaque,
                ),
              ),
              Positioned(
                left: position.dx,
                top: position.dy + size.height + 2,
                // Small offset to avoid overlap
                width: size.width,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero, // Remove default padding
                      shrinkWrap: true,
                      itemCount: QuoteGeneratorPage.generationTopics.length,
                      itemBuilder: (context, index) {
                        final topic = QuoteGeneratorPage.generationTopics.keys
                            .elementAt(index);
                        return ListTile(
                          title: Text(topic),
                          onTap: () {
                            setState(() {
                              _selectedTopic = topic;
                              _topicController.text = topic;
                            });
                            _topicFocusNode.unfocus();
                            _hideTopicOverlay();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_topicOverlayEntry!);
  }

  void _hideTopicOverlay() {
    _topicOverlayEntry?.remove();
    _topicOverlayEntry = null;
  }

  Future<void> _generateQuote() async {
    if (_selectedTeacherId == null || _selectedTopic == null) {
      Fluttertoast.showToast(msg: 'Выберите преподавателя и тему');
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$generateQuote'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'professor_id': _selectedTeacherId,
          'theme': QuoteGeneratorPage.generationTopics[_selectedTopic],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _generations.insert(
            0,
            GeneratedQuote(
              quote: data['quote'],
              teacher: _selectedTeacher ?? 'N/A',
              topic: _selectedTopic ?? 'N/A',
              number: ++_lastQuoteNumber,
            ),
          );
        });
      } else {
        throw Exception('Failed to generate quote');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ошибка генерации цитаты: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _removeQuote(int number) {
    setState(() {
      _generations.removeWhere((quote) => quote.number == number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Генератор цитат')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teacher Search Field
            TextField(
              key: _teacherFieldKey,
              controller: _teacherController,
              focusNode: _teacherFocusNode,
              decoration: const InputDecoration(
                labelText: 'Поиск преподавателя',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                if (_teacherResults.isNotEmpty) {
                  _showTeacherOverlay();
                }
              },
            ),
            const SizedBox(height: 16),
            // Topic Selector
            TextField(
              key: _topicFieldKey,
              controller: _topicController,
              focusNode: _topicFocusNode,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Выберите тему',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () {
                _showTopicOverlay();
              },
            ),
            const SizedBox(height: 16),
            // Generate Quote Button
            Center(
              child: ElevatedButton(
                onPressed: _isGenerating ? null : _generateQuote,
                child:
                    _isGenerating
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                        : const Text('Сгенерировать цитату'),
              ),
            ),
            const SizedBox(height: 16),
            // Generated Quotes List
            Column(
              children:
                  _generations.map((quote) {
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
