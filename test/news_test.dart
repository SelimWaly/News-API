import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_app_test/screens/news_screen.dart';

void main() {
  test('Test', () async {
    const url = 'https://newsapi.org/v2/top-headlines?country=eg&category=business&apiKey=feb8f8350bcc4da2b872cf7577dbec55';
    final response = await http.get(Uri.parse(url));

    expect(response.statusCode, 200, reason: 'Failed to fetch news');

    final jsonData = json.decode(response.body);
    final List<dynamic> articles = jsonData['articles'];

    expect(articles.isNotEmpty, true, reason: 'No articles found');
  });
}
