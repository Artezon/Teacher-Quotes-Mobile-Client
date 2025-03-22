import 'package:flutter/material.dart';
import '../model/filter_state.dart';

class FilterModal extends StatefulWidget {
  final FilterState currentFilters;

  const FilterModal({super.key, required this.currentFilters});

  static const Map<String, String> sortingOptionsStrings = {
    'newest': 'Сначала новые',
    'oldest': 'Сначала старые',
    'popular': 'Сначала популярные',
  };

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late String _keywords;
  late String _faculty;
  late String _teacher;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String _selectedSorting;

  @override
  void initState() {
    super.initState();
    _keywords = widget.currentFilters.keywords;
    _faculty = widget.currentFilters.facultyName;
    _teacher = widget.currentFilters.teacherName;
    _startDate = widget.currentFilters.startDate;
    _endDate = widget.currentFilters.endDate;
    _selectedSorting = widget.currentFilters.sorting;
  }

  void _applyFilters(BuildContext context) {
    Navigator.pop(
      context,
      FilterState()
        ..keywords = _keywords
        ..facultyName = _faculty
        ..teacherName = _teacher
        ..startDate = _startDate
        ..endDate = _endDate
        ..sorting = _selectedSorting,
    );
  }

  void _resetFilters() {
    Navigator.pop(context, FilterState());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Фильтры'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _keywords,
              onChanged: (value) => setState(() => _keywords = value),
              decoration: InputDecoration(labelText: 'Ключевые слова'),
            ),
            SizedBox(height: 8),
            // Faculty Dropdown with Loading State
            FutureBuilder<Map<String, int>?>(
              future: FilterState.allFaculties != null
                  ? Future.value(FilterState.allFaculties)
                  : FilterState.fetchAllFaculties(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Факультет (загрузка списка...)',
                    ),
                    items: [], // No items while loading
                    onChanged: null, // Disable interaction
                  );
                } else if (snapshot.hasError) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Факультет (ошибка загрузки)',
                    ),
                    items: [], // No items on error
                    onChanged: null, // Disable interaction
                  );
                } else {
                  final faculties = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _faculty.isNotEmpty ? _faculty : null,
                    decoration: InputDecoration(labelText: 'Факультет'),
                    items: faculties.keys.map((facultyName) {
                      return DropdownMenuItem(
                        value: facultyName,
                        child: Text(facultyName),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _faculty = value ?? ''),
                  );
                }
              },
            ),
            SizedBox(height: 8),
            // Teacher Dropdown with Loading State
            FutureBuilder<Map<String, int>?>(
              future: FilterState.allTeachers != null
                  ? Future.value(FilterState.allTeachers)
                  : FilterState.fetchAllTeachers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Преподаватель (загрузка списка...)',
                    ),
                    items: [], // No items while loading
                    onChanged: null, // Disable interaction
                  );
                } else if (snapshot.hasError) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Преподаватель (ошибка загрузки)',
                    ),
                    items: [], // No items on error
                    onChanged: null, // Disable interaction
                  );
                } else {
                  final teachers = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    value: _teacher.isNotEmpty ? _teacher : null,
                    decoration: InputDecoration(labelText: 'Преподаватель'),
                    items: teachers.keys.map((teacherName) {
                      return DropdownMenuItem(
                        value: teacherName,
                        child: Text(teacherName),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _teacher = value ?? ''),
                  );
                }
              },
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() => _startDate = pickedDate);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Начало периода',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _startDate
                            ?.toString()
                            .split(' ')[0]
                            .split('-')
                            .reversed
                            .join('.') ??
                            'С начала времён',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() => _endDate = pickedDate);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Конец периода',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _endDate
                            ?.toString()
                            .split(' ')[0]
                            .split('-')
                            .reversed
                            .join('.') ??
                            'До сегодня',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSorting,
              decoration: InputDecoration(labelText: 'Сортировка'),
              items: FilterModal.sortingOptionsStrings.entries
                  .map(
                    (option) => DropdownMenuItem(
                  value: option.key,
                  child: Text(option.value),
                ),
              )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedSorting = value ?? FilterModal.sortingOptionsStrings.keys.first),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                      });
                    },
                    child: Text('Сбросить даты'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: _resetFilters,
                    child: Text('Сбросить всё'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Отмена'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyFilters(context),
                    child: Text('Применить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
