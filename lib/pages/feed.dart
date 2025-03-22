import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_data.dart';
import '../model/filter_state.dart';
import '../model/quote_response.dart';
import '../widgets/quote_card.dart';
import '../widgets/filter_modal.dart';

class FeedPage extends StatefulWidget {
  final FilterState? predefinedFilters;

  const FeedPage({super.key, this.predefinedFilters});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String title = 'Лента';

  late Future<QuoteResponse> _quoteResponseFuture;
  static QuoteResponse? _cachedResponse;
  static int _currentPage = 1;
  static final int _pageSize = 20;
  bool _isLoadingMore = false; // Whether more data is being loaded
  static bool _endReached = false; // Whether there are no more quotes to load
  static bool _errorInfiniteScroll = false;

  late FilterState _filters;

  @override
  void initState() {
    super.initState();

    _filters = widget.predefinedFilters ?? FilterState();
    if (_filters.isFilterApplied()) _onRefresh();

    if (_cachedResponse == null) {
      _quoteResponseFuture = _fetchQuotes(
        _currentPage,
        _pageSize,
        _filters.toQueryParameters(),
      );
    } else {
      _quoteResponseFuture = Future.value(_cachedResponse);
    }
  }

  Future<QuoteResponse> _fetchQuotes(
    int page,
    int size,
    Map<String, String> filters,
  ) async {
    Map<String, String> queryParams = {
      'page': page.toString(),
      'size': size.toString(),
    };
    queryParams.addAll(filters);

    final response = await http.get(
      Uri.parse('$baseUrl$getQuotes').replace(queryParameters: queryParams),
    );

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final quoteResponse = QuoteResponse.fromJson(json.decode(utf8Body));
      if (_cachedResponse == null) {
        _cachedResponse = quoteResponse;
      } else {
        _cachedResponse!.content.addAll(quoteResponse.content);
        _cachedResponse!.dailyQuote = quoteResponse.dailyQuote;
      }
      if (quoteResponse.content.length < _pageSize) {
        setState(() {
          _endReached = true;
        });
      }
      return quoteResponse;
    } else {
      throw Exception('Failed to load quotes');
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _cachedResponse = null;
      _currentPage = 1;
      _endReached = false;
      _quoteResponseFuture = _fetchQuotes(
        _currentPage,
        _pageSize,
        _filters.toQueryParameters(),
      );
    });
  }

  void _loadMoreQuotes() async {
    if (_endReached || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final oldQuoteCount = _cachedResponse?.content.length;
      final nextPage = _currentPage + 1;
      await _fetchQuotes(nextPage, _pageSize, _filters.toQueryParameters());
      final newQuoteCount = _cachedResponse?.content.length;

      setState(() {
        _errorInfiniteScroll = false;
        if (newQuoteCount != oldQuoteCount) {
          _currentPage = nextPage;
        } else {
          _endReached = true;
        }
      });
    } catch (e) {
      setState(() {
        _errorInfiniteScroll = true;
      });
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _openFilterModal() async {
    final result = await showDialog<FilterState>(
      context: context,
      builder: (context) => FilterModal(currentFilters: _filters),
    );

    if (result != null) {
      setState(() {
        _filters = result;
      });
      _onRefresh();
    }
  }

  void _resetFilters() {
    setState(() {
      _filters = FilterState();
    });
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: _openFilterModal,
            child: Text(
              'Фильтры',
              style: TextStyle(
                color: Theme.of(context).iconTheme.color, // Matches icon color
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<QuoteResponse>(
          future: _quoteResponseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ошибка соединения',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Не удалось подключиться к серверу :(',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      child: Text('Попробовать ещё раз'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Показать сообщение об ошибке'),
                      onPressed:
                          () => showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Информация'),
                                content: Text(
                                  '${snapshot.error}\n${snapshot.stackTrace}',
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('Закрыть'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.content.isEmpty) {
              return Center(
                child: Builder(
                  builder: (context) {
                    final noQuotes = Text(
                      'Нет цитат',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                    if (_filters.isFilterApplied()) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          noQuotes,
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _resetFilters,
                            child: Text('Сбросить фильтры'),
                          ),
                        ],
                      );
                    } else {
                      return noQuotes;
                    }
                  },
                ),
              );
            } else {
              return Scrollbar(
                thickness: 5.0,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index < snapshot.data!.content.length) {
                            return QuoteCard(
                              data: snapshot.data!.content[index],
                              isDailyQuote:
                                  snapshot.data!.content[index].id ==
                                  snapshot.data!.dailyQuote?.id,
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Builder(
                                  builder: (context) {
                                    if (_endReached) {
                                      final allViewed = Text(
                                        'Вы всё посмотрели',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      );
                                      if (_filters.isFilterApplied()) {
                                        return Column(
                                          children: [
                                            allViewed,
                                            SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: _resetFilters,
                                              child: Text('Сбросить фильтры'),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return allViewed;
                                      }
                                    } else if (_errorInfiniteScroll) {
                                      return ElevatedButton(
                                        onPressed: _loadMoreQuotes,
                                        child: Text('Загрузить ещё цитаты'),
                                      );
                                    } else {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            _loadMoreQuotes();
                                          });
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            );
                          }
                        }, childCount: snapshot.data!.content.length + 1),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
