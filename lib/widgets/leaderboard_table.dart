import 'package:flutter/material.dart';

class LeaderboardTable extends StatelessWidget {
  final String nameColumnTitle;
  final List<Map<String, dynamic>> data;

  const LeaderboardTable({
    super.key,
    required this.nameColumnTitle,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
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
                      if (i < 3)
                        _buildPlaceNumber(i + 1)
                      else
                        _buildTableCell(Text((i + 1).toString())),
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

  Widget _buildTableCell(
    Widget child, {
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      alignment: alignment,
      child: child,
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
