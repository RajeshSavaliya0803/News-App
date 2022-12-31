import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:news_app_riverpod/utils/state_provider.dart';

class ApiProvider {
  final String baseURL = 'https://newsapi.org/';
  List<String> newsCatagory = [
    'globe',
    'politics',
    'movie',
    'india',
    'technology',
    'space',
    'soccer',
    'cricket',
    'business',
    'art',
    'IT',
    'party',
    'cars',
    'hypercars',
    'anime',
    'AI',
    'crypto',
    'Google',
  ];
  Future<http.Response> getNews({String? newsCat}) async {
    http.Response resp = await http.get(
      Uri.parse(
          '${baseURL}v2/everything?q=${newsCat ?? newsCatagory[Random().nextInt(newsCatagory.length)]}&sortBy=popularity&apiKey=${ProviderStorage.apiKey}'),
    );
    return resp;
  }
}
