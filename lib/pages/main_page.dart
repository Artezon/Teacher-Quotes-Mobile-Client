import 'package:flutter/material.dart';
import 'package:mq_mobile_quotes/pages/quote_generator_page.dart';
import 'package:mq_mobile_quotes/pages/top_page.dart';
import 'package:mq_mobile_quotes/pages/search_page.dart';
import 'feed.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;

  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final _pageOptions = [
    FeedPage(),
    TopPage(),
    SearchPage(),
    QuoteGeneratorPage(),
  ];

  Future<bool> _onWillPop() async {
    final NavigatorState currentNavigator = _navigatorKeys[selectedPage].currentState!;
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false; // Prevent exiting the app
    }
    if (selectedPage != 0) {
      setState(() {
        selectedPage = 0;
      });
      return false; // Prevent exiting the app
    }
    return true; // Allow app exit if no pages to pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: selectedPage,
          children: _navigatorKeys.map((key) {
            return Navigator(
              key: key,
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                  builder: (context) => _pageOptions[_navigatorKeys.indexOf(key)],
                );
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          onTap: (index) {
            if (selectedPage == index) {
              // If tapped on the currently selected tab, pop all pages until the root one
              _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
            } else {
              // If tapped on a different tab, switch to that tab
              setState(() {
                selectedPage = index;
              });
            }
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
        ),
      ),
    );
  }
}
