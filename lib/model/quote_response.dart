import 'quote.dart';

class QuoteResponse {
  final List<Quote> content;
  Quote? dailyQuote;

  QuoteResponse({required this.content, this.dailyQuote});

  factory QuoteResponse.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List;
    List<Quote> quotes = contentList.map((i) => Quote.fromJson(i)).toList();

    return QuoteResponse(
      content: quotes,
      dailyQuote: Quote.fromJson(json['dailyQuote']),
    );
  }
}