import 'package:covidtracer/model/post_model.dart';
import 'package:covidtracer/services/hospital_database_services.dart';
import 'package:covidtracer/themes/custom_colors.dart';
import 'package:covidtracer/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreatePostPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<HospitalDatabaseBase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: CustomColors.primaryBlue),
        title: Text(
          "Create Post",
          style: Theme.of(context).textTheme.headline5,
        ),
        centerTitle: true,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              hintStyle: TextStyle(color: Colors.black54),
            ),
            style: Theme.of(context).textTheme.headline6,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 300,
            maxLines: 10,
          ),
          SizedBox(height: 30.0),
          CustomButton(
            desktopMaxWidth: MediaQuery.of(context).size.width / 1.0,
            buttonHeight: 60.0,
            buttonTitle: "Post Now",
            buttonColor: CustomColors.primaryBlue,
            textColor: Colors.white,
            buttonRadius: 3.0,
            onPressed: () async {
              final String hospitalId = FirebaseAuth.instance.currentUser.uid;
              final String uid = Uuid().v4();
              final PostModel post = PostModel(
                posts: _controller.text,
                id: uid,
                hospital_Id: hospitalId,
                created: DateTime.now(),
              );
              await database.createPosts(post);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
