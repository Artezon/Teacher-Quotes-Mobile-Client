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
            TextFormField(
              initialValue: _faculty,
              onChanged: (value) => setState(() => _faculty = value),
              decoration: InputDecoration(labelText: 'Факультет'),
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: _teacher,
              onChanged: (value) => setState(() => _teacher = value),
              decoration: InputDecoration(labelText: 'Преподаватель'),
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
              items:
                  FilterModal.sortingOptionsStrings.entries
                      .map(
                        (option) => DropdownMenuItem(
                          value: option.key,
                          child: Text(option.value),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(
                    () =>
                        _selectedSorting =
                            value ??
                            FilterModal.sortingOptionsStrings.keys.first,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          // Ensure the column takes minimal space
          children: [
            // First Row: Сбросить даты | Сбросить всё
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _startDate = null; // Reset start date
                        _endDate = null; // Reset end date
                      });
                    },
                    child: Text('Сбросить даты'),
                  ),
                ),
                SizedBox(width: 8), // Add spacing between buttons
                Expanded(
                  child: TextButton(
                    onPressed: _resetFilters, // Reset all filters
                    child: Text('Сбросить всё'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Add spacing between rows
            // Second Row: Отмена | Применить
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context), // Cancel
                    child: Text('Отмена'),
                  ),
                ),
                SizedBox(width: 8), // Add spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyFilters(context), // Apply filters
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
