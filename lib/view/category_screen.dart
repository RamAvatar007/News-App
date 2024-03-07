import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/view_model/category_view_model.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/categories_news_model.dart';
import 'news_detailes_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoriesViewModel categoriesViewModel = CategoriesViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String categoryName = 'General';
  List<String> categoriesList = ['General', 'Entertainment', 'Health', 'Sports', 'Business', 'Technology'];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: 'Category'.text.bold.size(27).make(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    categoryName = categoriesList[index];
                    setState(() {});
                  },
                  child: Container(
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: categoryName == categoriesList[index] ? Colors.blue[900] : Colors.blueGrey[600],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: Center(child: categoriesList[index].toString().text.color(Colors.white).make()),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: height *.025,),
          Expanded(
            child:
            FutureBuilder(
              future: categoriesViewModel.fetchCategoriesNewsApi (categoryName),
              builder: (BuildContext context,AsyncSnapshot<CategoriesNewsModel> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreen(
                              newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                              sourceName: snapshot.data!.articles![index].source!.name.toString(),
                              title: snapshot.data!.articles![index].title.toString(),
                              description: snapshot.data!.articles![index].description.toString(),
                              publishedAt: snapshot.data!.articles![index].publishedAt.toString(),
                              content: snapshot.data!.articles![index].content.toString(),
                            ),));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child:
                                CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.fill,height: height * .18,width: width * .3,
                                  errorWidget: (context, url, error) => const Icon(Icons.error_outline_rounded,
                                    color: Colors.red,size: 50,),
                                  placeholder: (context, url) => const Center(
                                    child: SpinKitCircle(
                                      size: 50,color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                              height: height * .18,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      snapshot.data!.articles![index].title.toString().text.maxLines(3).size(16).fontWeight(FontWeight.w600).makeCentered(),
                                      const Spacer(),
                                      'Date: ${format.format(dateTime).toString()}'.text.size(14).make(),
                                      SizedBox(height: height * .02,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
