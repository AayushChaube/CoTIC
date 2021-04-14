class PostModel {
  final String posts;
  final DateTime created;
  final String hospital_Id;
  final String id;

  PostModel({
    this.posts = "",
    this.created,
    this.hospital_Id = "",
    this.id = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "hospital_Id": hospital_Id,
      "id": id,
      "created": created,
      "posts": posts,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      created: data["created"].toDate(),
      hospital_Id: data["hospital_Id"],
      id: data["id"],
      posts: data["posts"],
    );
  }
}
