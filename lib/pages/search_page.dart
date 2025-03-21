import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../api_data.dart';
import '../utils/faculty_formatting.dart';
import 'detailed_info.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(_searchController.text);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.length < 2) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final teachersResponse = await http.get(
        Uri.parse('$baseUrl$getTeachers?name=$query&size=50'),
      );
      final facultiesResponse = await http.get(
        Uri.parse('$baseUrl$getFaculties?name=$query&size=50'),
      );

      if (teachersResponse.statusCode == 200 &&
          facultiesResponse.statusCode == 200) {
        final teachersData = json.decode(utf8.decode(teachersResponse.bodyBytes));
        final facultiesData = json.decode(utf8.decode(facultiesResponse.bodyBytes));

        final List<dynamic> combinedResults = [
          ...teachersData['teachers'].map(
            (t) => {
              'type': ContentType.teacher,
              'id': t['id'],
              'name': t['fullname'],
            },
          ),
          ...facultiesData['faculties'].map(
            (f) => {
              'type': ContentType.faculty,
              'id': f['id'],
              'name': formatFaculty(f['name']),
            },
          ),
        ];

        setState(() {
          _searchResults = combinedResults;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Ошибка поиска: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Введите запрос здесь...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[800]),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _searchController.text.length < 2
                        ? 'Введите запрос для поиска преподавателей и факультетов'
                        : 'Ничего не найдено',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey[200],
                      elevation: 0,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetailedInfoPage(
                                    contentType: item['type'],
                                    id: item['id'],
                                  ),
                            ),
                          );
                        },
                        title: Text(
                          item['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item['type'] == ContentType.teacher
                              ? 'Преподаватель'
                              : 'Факультет',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
