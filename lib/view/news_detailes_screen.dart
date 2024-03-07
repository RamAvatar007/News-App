import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class NewsDetailsScreen extends StatelessWidget {
  String newsImage, sourceName, title, description, publishedAt, content;
  NewsDetailsScreen({
    super.key,
    required this.newsImage,
    required this.sourceName,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.content,
  });

  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    DateTime dateTime = DateTime.parse(publishedAt);
    return Scaffold(
      appBar: AppBar(
        title: 'News Details'.text.bold.size(27).make(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(21), topRight: Radius.circular(21)),
            child: CachedNetworkImage(
              imageUrl: newsImage.toString(),
              fit: BoxFit.fill,
              height: height * .45,
              width: width * 1,
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
          Container(
            margin: EdgeInsets.only(top: height * .43),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(21), topRight: Radius.circular(21)), color: Colors.white),
            child: Column(
              children: [
                title.toString().text.maxLines(3).size(17).fontWeight(FontWeight.w700).makeCentered(),
                SizedBox(
                  height: height * .035,
                ),
                Row(
                  children: [
                    Expanded(child: "Source Name : $sourceName".text.size(14).fontWeight(FontWeight.w600).make()),
                    format.format(dateTime).text.size(14).fontWeight(FontWeight.w500).make(),
                  ],
                ),
                SizedBox(
                  height: height * .045,
                ),
                content.toString().text.size(15).fontWeight(FontWeight.w500).makeCentered(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
