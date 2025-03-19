import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../api_data.dart';
import 'package:flutter/services.dart';
import '../styles/theme.dart';

enum ContentType { faculty, teacher }

class DetailedInfoPage extends StatefulWidget {
  final ContentType contentType;
  final int id;

  const DetailedInfoPage({
    super.key,
    required this.contentType,
    required this.id,
  });

  @override
  State<DetailedInfoPage> createState() => _DetailedInfoPageState();
}

class _DetailedInfoPageState extends State<DetailedInfoPage> {
  late String title;
  bool isLoading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String _getQueryParam() {
    switch (widget.contentType) {
      case ContentType.faculty:
        return 'facultyId';
      case ContentType.teacher:
        return 'teacherId';
    }
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl$search?${_getQueryParam()}=${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(utf8.decode(response.bodyBytes));
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ошибка загрузки данных: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    title =
        widget.contentType == ContentType.faculty
            ? 'Информация о факультете'
            : 'Информация о преподавателе';

    String name = data?['name'] ?? 'N/A';
    if (widget.contentType == ContentType.faculty) {
      name = name.replaceAll('_', ' ');
      name = "${name[0].toUpperCase()}${name.substring(1)}";
      name = name.replaceAll("кубгу", "КубГУ");
    }

    Widget facultiesOrSubjects;
    if (widget.contentType == ContentType.faculty) {
      facultiesOrSubjects = _buildListSection(
        'Преподаватели',
        data?['teachers']
            ?.map<String>((teacher) => (teacher as Map<String, dynamic>)['name'] as String)
            .toList() ??
            [],
      );
    } else {
      facultiesOrSubjects = _buildListSection(
        'Факультеты',
        data?['faculties']
            ?.map<String>((faculty) {
              String name = (faculty as Map<String, dynamic>)['name'] as String;
              name = name.replaceAll('_', ' ');
              name = "${name[0].toUpperCase()}${name.substring(1)}";
              name = name.replaceAll("кубгу", "КубГУ");
              return name;
            })
            .toList() ??
            [],
      );
    }

    String description = data?['description'] ?? 'Нет описания';
    if (description.isEmpty) description = 'Нет описания';


    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Material(
                      elevation: 2.0,
                      child: Container(
                        color: Colors.grey[200],
                        padding: AppStyles.horizontalPadding.copyWith(
                          top: 16,
                          bottom: 16,
                        ),
                        width: double.infinity,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: AppStyles.horizontalPadding.copyWith(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection(
                            context,
                            'Описание',
                            description,
                          ),
                          facultiesOrSubjects,
                          _buildListSection(
                            'Дисциплины',
                            data?['subjects']
                                ?.map<String>((subject) => (subject as Map<String, dynamic>)['name'] as String)
                                .toList() ??
                                [],
                          ),
                          _buildStatsSection(
                            data?['countQuotes']?.toString() ?? '0',
                            data?['countReactions']?.toString() ?? '0',
                          ),
                          _buildInfoSection(
                            context,
                            'Дата последней публикации',
                            data?['dateLastPublication']?.toString().split('-').reversed.join('.') ?? 'Неизвестно',
                          ),
                          const SizedBox(height: 24),
                          _buildQuoteButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String value) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title:', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          GestureDetector(
            onLongPress: () => _copyToClipboard(context, value),
            child: Text(value, style: AppStyles.regularText),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title:', style: AppStyles.sectionTitle),
          const SizedBox(height: 8),
          ...items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $item', style: AppStyles.regularText),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(String quotes, String reactions) {
    return Padding(
      padding: AppStyles.cardPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Количество цитат:', style: AppStyles.sectionTitle),
                const SizedBox(height: 4),
                Text(quotes, style: AppStyles.regularText),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Количество реакций:', style: AppStyles.sectionTitle),
                const SizedBox(height: 4),
                Text(reactions, style: AppStyles.regularText),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text('Перейти к цитатам'),
      ),
    );
  }

  // Future<void> _launchUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(msg: 'Скопировано: $text');
    HapticFeedback.vibrate();
  }
}
