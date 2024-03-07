
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/repository/news_repository.dart';

class CategoriesViewModel{
  final _rep = NewsRepository();

  Future<CategoriesNewsModel> fetchCategoriesNewsApi (String category)async{
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}