
import 'package:baby2body/env.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:newsapi/newsapi.dart';

class DataBuilder {
  List<Article> articles = [];
  Map<String, dynamic> map = {};

  Future<void> getNews({required String query}) async {
    var newsApi = NewsApi(
      debugLog: false,
      apiKey: newsapikey,
    );

    ArticleResponse response =
        await newsApi.everything(q: query, language: 'en', sortBy: 'relevancy');

    articles = response.articles ?? [];
    map.putIfAbsent('news', () => response.articles);
  }

  Future<void> getCredentials() async {
    var credentials =
        await DialogAuthCredentials.fromFile("assets/dialogflow.json");
    map.putIfAbsent('credentials', () => credentials);
  }

  Future<Map<String, dynamic>> dataBuilder({required String query}) async {
    await getNews(query: query);
    await getCredentials();

    return map;
  }
}
