import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_headline_model.dart';
import 'package:news_app/view_model/news_channel_view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/categories_news_model.dart';
import '../view_model/category_view_model.dart';
import 'category_screen.dart';
import 'news_detailes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  CategoriesViewModel categoriesViewModel = CategoriesViewModel();


  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: 'News'.text.fontWeight(FontWeight.w700).size(27).make(),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ));
            },
            icon: Image.asset(
              'assets/images/category_icon.png',
              height: 25,
              width: 25,
            )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * .45,
            width: width,
            child: FutureBuilder(
              future: newsViewModel.fetchNewsChannelHeadlineApi(),
              builder: (BuildContext context,AsyncSnapshot<NewsChannelHeadlineModel> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  print("data ${snapshot.data?.articles}");
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.articles?.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDetailsScreen(
                                  newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  sourceName: snapshot.data!.articles![index].source!.name.toString(),
                                  title: snapshot.data!.articles![index].title.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  publishedAt: snapshot.data!.articles![index].publishedAt.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                ),
                              ));
                        },
                        child: Container(
                          child: Stack(
                            children: [
                              Container(
                                width: width * .95,
                                height: height * .6,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: SpinKitCircle(
                                        size: 50,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: width * .07,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    width: width * .8,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        snapshot.data!.articles![index].title.toString().text.size(12).bold.make(),
                                        SizedBox(
                                          height: height * .04,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            snapshot.data!.articles![index].source!.name.toString().text.size(12).bold.make(),
                                            format.format(dateTime).text.size(12).bold.make(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
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
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: FutureBuilder(
              future: categoriesViewModel.fetchCategoriesNewsApi('General'),
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
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailsScreen(
                                    newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                   // newsImage: " ",
                                    sourceName: snapshot.data!.articles![index].source!.name.toString(),
                                    title: snapshot.data!.articles![index].title.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    publishedAt: snapshot.data!.articles![index].publishedAt.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                  ),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.fill,
                                  height: height * .18,
                                  width: width * .3,
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error_outline_rounded,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  placeholder: (context, url) => const Center(
                                    child: SpinKitCircle(
                                      size: 50,
                                      color: Colors.blue,
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
                                      SizedBox(
                                        height: height * .02,
                                      ),
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
          )
        ],
      ),
    );
  }
}
