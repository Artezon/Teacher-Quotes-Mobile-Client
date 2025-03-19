import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_data.dart';

class FilterState {
  static final List<String> sortingOptions = ['newest', 'oldest', 'popular'];

  static Map<String, int>? allFaculties;
  static Map<String, int>? allTeachers;

  String keywords = '';
  String facultyName = 'Все факультеты';
  String teacherName = 'Все преподаватели';
  DateTime? startDate;
  DateTime? endDate;
  String sorting = sortingOptions[0];

  static Future<Map<String, int>> fetchAllFaculties() async {
    Map<String, int> facultiesMap = {};
    facultiesMap['Все факультеты'] = -1;
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
    allFaculties = facultiesMap;
    return facultiesMap;
  }

  static Future<Map<String, int>> fetchAllTeachers() async {
    Map<String, int> teachersMap = {};
    teachersMap['Все преподаватели'] = -1;
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
    allTeachers = teachersMap;
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
    if (facultyName.isNotEmpty && facultyName != 'Все факультеты') params['facultyId'] = allFaculties?[facultyName].toString() ?? '';
    if (teacherName.isNotEmpty && teacherName != 'Все преподаватели') params['teacherId'] = allTeachers?[teacherName].toString() ?? '';
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
