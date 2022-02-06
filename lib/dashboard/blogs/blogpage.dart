import 'package:baby2body/constants/month.dart';
import 'package:baby2body/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapi/newsapi.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({Key? key, required this.list}) : super(key: key);
  final List<Article> list;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (list.isEmpty)
        ? Center(
            child: Text(
              'No Blogs Avaialble',
              style: mediumtextsyle(
                size: size.width / 20,
              ),
            ),
          )
        : ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Blogs",
                  style: boldtextsyle(size: size.width / 10, shadow: true),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: FeaturedArticle(
                    article: list[0],
                  )),
              if (list.length > 1)
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: NewsGrid(
                      list: list.sublist(1),
                    )),
            ],
          );
  }
}

class FeaturedArticle extends StatelessWidget {
  const FeaturedArticle({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        if (!await launch(article.url)) {
          Get.snackbar('Error', 'Could not launch from ${article.source}');
          throw 'Could not launch from ${article.source}';
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    article.urlToImage,
                    fit: BoxFit.cover,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(blurRadius: 10, color: Colors.grey)
                    ]),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text(
                    'FEATURED',
                    style: mediumtextsyle(
                        size: size.width / 25, color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.width / 50,
          ),
          Text(
            '${article.publishedAt.day} ${getMonth(article.publishedAt.month)} ',
            style:
                mediumtextsyle(size: size.width / 28, color: Colors.grey[600]),
          ),
          SizedBox(
            height: size.width / 50,
          ),
          Text(
            article.title,
            style:
                mediumtextsyle(size: size.width / 18, color: Colors.grey[900]),
          ),
          Text(
            article.description,
            style:
                normaltextsyle(size: size.width / 24, color: Colors.grey[700]),
          ),
          SizedBox(
            height: size.width / 50,
          ),
          const Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class NewsGrid extends StatelessWidget {
  const NewsGrid({Key? key, required this.list}) : super(key: key);
  final List<Article> list;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: (list.length < 16) ? list.length : 16,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 25,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                if (!await launch(list[index].url)) {
                  Get.snackbar(
                      'Error', 'Could not launch from ${list[index].source}');
                  throw 'Could not launch from ${list[index].source}';
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          list[index].urlToImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    height: size.width / 80,
                  ),
                  Text(
                    '${list[index].publishedAt.day} ${getMonth(list[index].publishedAt.month)} ',
                    style: mediumtextsyle(
                        size: size.width / 34, color: Colors.grey[600]),
                  ),
                  SizedBox(
                    height: size.width / 70,
                  ),
                  Text(
                    list[index].title,
                    style: mediumtextsyle(size: size.width / 25),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
