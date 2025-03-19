import 'package:flutter/material.dart';

class LeaderboardTable extends StatelessWidget {
  final String nameColumnTitle;

  static const List<Map<String, dynamic>> data = [
    {'name': 'Иванов И.И.', 'score': 1000},
    {'name': 'Петров П.П.', 'score': 950},
    {'name': 'Сидоров С.С.', 'score': 900},
    {'name': 'Орлов О.О.', 'score': 850},
    {'name': 'Кузнецов К.К.', 'score': 800},
    {'name': 'Лебедев Л.Л.', 'score': 750},
    {'name': 'Зайцев З.З.', 'score': 700},
  ];

  const LeaderboardTable({super.key, required this.nameColumnTitle});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth, // Ensure the table doesn't exceed screen width
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: {
                0: IntrinsicColumnWidth(), // First column: minimum width
                1: FlexColumnWidth(), // Second column: flexible width
                2: IntrinsicColumnWidth(), // Third column: minimum width
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    _buildTableCell(_buildHeaderText('Место')),
                    _buildTableCell(_buildHeaderText(nameColumnTitle)),
                    _buildTableCell(_buildHeaderText('Реакции')),
                  ],
                ),
                for (int i = 0; i < data.length; i++) ...[
                  TableRow(
                    children: [
                      if (i < 3) _buildPlaceNumber(i + 1)
                      else _buildTableCell(Text((i + 1).toString())),
                      _buildTableCell(Text(data[i]['name'])),
                      _buildTableCell(Text(data[i]['score'].toString())),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableCell(Widget child, {Alignment alignment = Alignment.center}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      alignment: alignment,
      child: child,
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildPlaceNumber(int number) {
    double iconSize = 36.0;
    Color iconColor = winningMetalsColorPalette[number] ?? Color(0xFF000000);

    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.star, size: iconSize, color: iconColor),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: iconSize * 0.3,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

Map<int, Color> winningMetalsColorPalette = {
  1: Color(0xFFD4AF37),
  2: Color(0xFFC0C0C0),
  3: Color(0xFFCD7F32),
};
