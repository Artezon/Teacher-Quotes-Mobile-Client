import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_data.dart';

class FilterState {
  static final List<String> sortingOptions = ['newest', 'oldest', 'popular'];

  static Map<String, int>? allFaculties;
  static Map<String, int>? allTeachers;

  String keywords = '';
  String facultyName = '';
  String teacherName = '';
  DateTime? startDate;
  DateTime? endDate;
  String sorting = sortingOptions[0];

  FilterState() {
    _fetchAllFacultiesAndTeachers();
  }

  Future<void> _fetchAllFacultiesAndTeachers() async {
    try {
      allFaculties = await _fetchAllFaculties();
      allTeachers = await _fetchAllTeachers();
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<Map<String, int>> _fetchAllFaculties() async {
    Map<String, int> facultiesMap = {};
    int page = 1;

    while (true) {
      final response = await http.get(Uri.parse('$baseUrl$getFaculties?size=100&page=$page&sort_by=name'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        final faculties = List<Map<String, dynamic>>.from(jsonResponse['faculties']);
        for (var faculty in faculties) {
          String name = faculty['name'];
          name = name.replaceAll('_', ' ');
          name = "${name[0].toUpperCase()}${name.substring(1)}";
          name = name.replaceAll("кубгу", "КубГУ");
          facultiesMap[name] = faculty['id'];
        }
        if (jsonResponse['totalElements'] <= page * 100) break;
        page++;
      } else {
        throw Exception('Failed to load faculties');
      }
    }
    return facultiesMap;
  }

  Future<Map<String, int>> _fetchAllTeachers() async {
    Map<String, int> teachersMap = {};
    int page = 1;

    while (true) {
      final response = await http.get(Uri.parse('$baseUrl$getTeachers?size=100&page=$page&sort_by=fullname'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        final teachers = List<Map<String, dynamic>>.from(jsonResponse['teachers']);
        for (var teacher in teachers) {
          teachersMap[teacher['fullname']] = teacher['id'];
        }
        if (jsonResponse['totalElements'] <= page * 100) break;
        page++;
      } else {
        throw Exception('Failed to load teachers');
      }
    }
    return teachersMap;
  }

  bool isFilterApplied() {
    return keywords != '' ||
        facultyName != '' ||
        teacherName != '' ||
        startDate != null ||
        endDate != null ||
        sorting != sortingOptions[0];
  }

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};
    if (keywords.isNotEmpty) params['text'] = keywords;
    if (facultyName.isNotEmpty) params['facultyId'] = allFaculties?[facultyName].toString() ?? '';
    if (teacherName.isNotEmpty) params['teacherId'] = allTeachers?[teacherName].toString() ?? '';
    if (startDate != null) params['startDate'] = toDateString(startDate!);
    if (endDate != null) params['endDate'] = toDateString(endDate!);
    switch (sorting) {
      case 'newest':
        params['sort_by'] = 'date';
        params['sort_direction'] = 'desc';
        break;
      case 'oldest':
        params['sort_by'] = 'date';
        params['sort_direction'] = 'asc';
        break;
      case 'popular':
        params['sort_by'] = 'reactions';
        params['sort_direction'] = 'desc';
        break;
    }
    return params;
  }

  String toDateString(DateTime datetime) {
    return datetime.toString().split(' ')[0];
  }
}
