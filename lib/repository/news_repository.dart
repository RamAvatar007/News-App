import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_headline_model.dart';

class NewsRepository{

    Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
      String categoryUrl = "https://newsapi.org/v2/everything?q=$category&apiKey=72ae971444ac440888959d7a87ecb21d";
      if (kDebugMode) {
        print("CategoryUrl======$categoryUrl");
      }
      final response = await get(Uri.parse(categoryUrl));
      if(response.statusCode == 200){
        if (kDebugMode) {
          print("statusCode======${response.statusCode.toString()}");
          print("Response======${response.body}");
        }
        final body = jsonDecode(response.body);
        return CategoriesNewsModel.fromJson(body);
      }else{
        throw Exception('Error');
      }
    }





    Future<NewsChannelHeadlineModel> fetchNewsChannelHeadlineApi() async {
    String newUrl = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=72ae971444ac440888959d7a87ecb21d";
    if (kDebugMode) {
      print("NewsUrl======$newUrl");
    }
    final response =await get(Uri.parse(newUrl));
    if(response.statusCode == 200){
      if (kDebugMode) {
        print("statusCode======${response.statusCode.toString()}");
        print("Response======${response.body}");
      }
       final body = jsonDecode(response.body);
       return NewsChannelHeadlineModel.fromJson(body);
    }else{
      throw Exception('Error');
    }
  }
}