import 'package:covidtracer/hospital_pages/post_page/create_post_page.dart';
import 'package:covidtracer/model/post_model.dart';
import 'package:covidtracer/services/hospital_database_services.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PostPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<HospitalDatabaseBase>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.primaryBlue,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreatePostPage(),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.post_add,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<PostModel>>(
          stream: database.getPostsLists(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                List<PostModel> query = snapshot.data;
                final String hospitalId = FirebaseAuth.instance.currentUser.uid;
                query.removeWhere(
                    (element) => element.hospital_Id != hospitalId);
                if (query.isEmpty) {
                  return Center(
                    child: Text(
                      "No Posts Found",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
                return Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: query.length,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        query[index].posts,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  ),
                );

              default:
                return Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }
}
