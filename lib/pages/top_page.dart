import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_data.dart';
import '../widgets/leaderboard_table.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  final List<String> contentTypes = ['Преподаватели', 'Факультеты'];
  final List<String> timePeriods = ['Неделя', 'Месяц', 'Год', 'Всё время'];

  String _title = 'Топ преподавателей';

  String? _selectedContentType;
  String? _selectedTimePeriod;

  // bool _isLoading = false;
  late Future<Map<String, dynamic>> _dataResponseFuture;
  List<Map<String, dynamic>> _tableData = [];

  @override
  void initState() {
    super.initState();

    _selectedContentType = contentTypes[0];
    _selectedTimePeriod = timePeriods[0];
    _dataResponseFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    // setState(() {
    //   _isLoading = true;
    // });

    final String endpoint =
        _selectedContentType == 'Преподаватели'
            ? '$baseUrl$topTeachers'
            : '$baseUrl$topFaculties';

    final String interval = switch (_selectedTimePeriod) {
      'Неделя' => '?interval=week',
      'Месяц' => '?interval=month',
      'Год' => '?interval=year',
      _ => '',
    };

    try {
      final response = await http.get(Uri.parse('$endpoint$interval'));

      if (response.statusCode == 200) {
        final utf8Body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(utf8Body);
        setState(() {
          _tableData = List<Map<String, dynamic>>.from(
            data['content'].map(
              (item) => {'name': item['name'], 'score': item['countReactions']},
            ),
          );
        });
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // First Dropdown for Content Type
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedContentType,
                    items:
                        contentTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedContentType = newValue;
                        _title =
                            newValue == 'Преподаватели'
                                ? 'Топ преподавателей'
                                : 'Топ факультетов';
                        _dataResponseFuture = _fetchData();
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 10), // Add some spacing between the dropdowns
                // Second Dropdown for Time Period
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimePeriod,
                    items:
                        timePeriods.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimePeriod = newValue;
                        _dataResponseFuture = _fetchData();
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Table Widget
            FutureBuilder<Map<String, dynamic>>(
              future: _dataResponseFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ошибка соединения',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Не удалось подключиться к серверу :(',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _dataResponseFuture = _fetchData();
                            });
                          },
                          child: Text('Попробовать ещё раз'),
                        ),
                      ],
                    ),
                  );
                } else {
                  if (_tableData.isNotEmpty) {
                    return Expanded(
                      child: LeaderboardTable(
                        nameColumnTitle:
                            _selectedContentType == 'Преподаватели'
                                ? 'Преподаватель'
                                : 'Факультет',
                        data: _tableData,
                      ),
                    );
                  } else {
                    return Text('Нет данных за текущий интервал');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
