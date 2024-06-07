import 'package:news_app_test/screens/news_screen.dart';

abstract class NewsStates {}

class NewsInitial extends NewsStates {}

class NewsLoading extends NewsStates {}

class NewsSuccess extends NewsStates {
  final List<NewsArticle> articles;

  NewsSuccess({required this.articles});
}

class NewsError extends NewsStates {
  final String message;

  NewsError({required this.message});
}