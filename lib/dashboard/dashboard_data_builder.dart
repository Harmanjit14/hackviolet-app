import 'package:baby2body/env.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapi/newsapi.dart';

class DataBuilder {
  List<Article> articles = [];
  Map<String, dynamic> map = {};
  Map<int, int> caldays = {};

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

  Future<void> getDays() async {
    var data = await FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();

    for (var obj in data.docs) {
      int day = obj.get('day');
      int month = obj.get('month');
      caldays.putIfAbsent(day, () => month);
    }
    map.putIfAbsent('days', () => caldays);
  }

  Future<Map<String, dynamic>> dataBuilder({required String query}) async {
    await getNews(query: query);
    await getCredentials();
    await getDays();

    return map;
  }
}
