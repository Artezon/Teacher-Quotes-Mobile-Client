import 'package:flutter/material.dart';
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

  String? selectedContentType;
  String? selectedTimePeriod;

  @override
  void initState() {
    super.initState();

    selectedContentType = contentTypes[0];
    selectedTimePeriod = timePeriods[0];
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
                    value: selectedContentType,
                    items:
                        contentTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedContentType = newValue;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 10), // Add some spacing between the dropdowns
                // Second Dropdown for Time Period
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTimePeriod,
                    items:
                        timePeriods.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimePeriod = newValue;
                      });
                    },
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Table Widget
            Expanded(
              child: LeaderboardTable(
                nameColumnTitle:
                    selectedContentType == 'Преподаватели'
                        ? 'Преподаватель'
                        : 'Факультет',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
