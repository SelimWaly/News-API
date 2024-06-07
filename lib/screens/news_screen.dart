import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_test/data/cubit/news_state.dart';
import 'package:news_app_test/data/cubit/news_cubit.dart';

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}

class NewsScreen extends StatelessWidget {
  final String country;

  const NewsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsCubit()..fetchNews(country),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<NewsCubit>().fetchNews(country);
              },
            ),
          ],
        ),
        body: BlocBuilder<NewsCubit, NewsStates>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsSuccess) {
              final articles = state.articles;
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      // Handle article tap
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article.urlToImage.isNotEmpty)
                              Image.network(article.urlToImage),
                            const SizedBox(height: 8.0),
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              article.description,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Published at: ${article.publishedAt}',
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is NewsError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Press the refresh button to load news.'));
            }
          },
        ),
      ),
    );
  }
}

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitial());

  Future<void> fetchNews(String country) async {
    emit(NewsLoading());
    final url =
        'https://newsapi.org/v2/top-headlines?country=$country&category=business&apiKey=feb8f8350bcc4da2b872cf7577dbec55';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> articlesJson = jsonData['articles'];
        final articles = articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
        emit(NewsSuccess(articles: articles));
      } else {
        emit(NewsError(message: 'Failed to load news'));
      }
    } catch (error) {
      emit(NewsError(message: error.toString()));
    }
  }
}
