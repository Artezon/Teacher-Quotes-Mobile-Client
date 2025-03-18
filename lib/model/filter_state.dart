class FilterState {
  static final List<String> sortingOptions = ['newest', 'oldest', 'popular'];

  String keywords = '';
  int facultyId = -1;
  String facultyName = '';
  int teacherId = -1;
  String teacherName = '';
  DateTime? startDate;
  DateTime? endDate;
  String sorting = sortingOptions[0];

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
    if (facultyId != -1) params['facultyId'] = facultyId.toString();
    if (teacherId != -1) params['teacherId'] = teacherId.toString();
    if (startDate != null)
      params['startDate'] = startDate!.toString().split(' ')[0];
    if (endDate != null) params['endDate'] = endDate!.toString().split(' ')[0];
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
}
