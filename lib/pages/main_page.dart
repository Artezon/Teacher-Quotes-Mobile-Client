import 'package:flutter/material.dart';
import 'feed.dart';
import 'faculty_info.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;

  final _pageOptions = [
    FeedPage(),
    FacultyInfoPage(),
    FeedPage(),
    FeedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'Лента',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded),
              label: 'Топ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Поиск',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_comment_outlined),
              label: 'Генерация',
            ),
          ],
        )
    );
  }
}