/// posts : [{"id":1,"title":"His mother had always taught him","body":"His mother had always taught him not to ever think of himself as better than others. He'd tried to live by this motto. He never looked down on those who were less fortunate or who had less money than him. But the stupidity of the group of people he was talking to made him change his mind.","tags":["history","american","crime"],"reactions":{"likes":192,"dislikes":25},"views":305,"userId":121},{"id":2,"title":"He was an expert but not in a discipline","body":"He was an expert but not in a discipline that anyone could fully appreciate. He knew how to hold the cone just right so that the soft server ice-cream fell into it at the precise angle to form a perfect cone each and every time. It had taken years to perfect and he could now do it without even putting any thought behind it.","tags":["french","fiction","english"],"reactions":{"likes":859,"dislikes":32},"views":4884,"userId":91},{"id":3,"title":"Dave watched as the forest burned up on the hill.","body":"Dave watched as the forest burned up on the hill, only a few miles from her house. The car had been hastily packed and Marta was inside trying to round up the last of the pets. Dave went through his mental list of the most important papers and documents that they couldn't leave behind. He scolded himself for not having prepared these better in advance and hoped that he had remembered everything that was needed. He continued to wait for Marta to appear with the pets, but she still was nowhere to be seen.","tags":["magical","history","french"],"reactions":{"likes":1448,"dislikes":39},"views":4152,"userId":16}]
/// total : 251
/// skip : 0
/// limit : 3

class PostModel {
  PostModel({
      this.posts, 
      this.total, 
      this.skip, 
      this.limit,});

  PostModel.fromJson(dynamic json) {
    if (json['posts'] != null) {
      posts = [];
      json['posts'].forEach((v) {
        posts?.add(Posts.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }
  List<Posts>? posts;
  num? total;
  num? skip;
  num? limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (posts != null) {
      map['posts'] = posts?.map((v) => v.toJson()).toList();
    }
    map['total'] = total;
    map['skip'] = skip;
    map['limit'] = limit;
    return map;
  }

}

/// id : 1
/// title : "His mother had always taught him"
/// body : "His mother had always taught him not to ever think of himself as better than others. He'd tried to live by this motto. He never looked down on those who were less fortunate or who had less money than him. But the stupidity of the group of people he was talking to made him change his mind."
/// tags : ["history","american","crime"]
/// reactions : {"likes":192,"dislikes":25}
/// views : 305
/// userId : 121

class Posts {
  Posts({
      this.id, 
      this.title, 
      this.body, 
      this.tags, 
      this.reactions, 
      this.views, 
      this.userId,});

  Posts.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    reactions = json['reactions'] != null ? Reactions.fromJson(json['reactions']) : null;
    views = json['views'];
    userId = json['userId'];
  }
  num? id;
  String? title;
  String? body;
  List<String>? tags;
  Reactions? reactions;
  num? views;
  num? userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['tags'] = tags;
    if (reactions != null) {
      map['reactions'] = reactions?.toJson();
    }
    map['views'] = views;
    map['userId'] = userId;
    return map;
  }

}

/// likes : 192
/// dislikes : 25

class Reactions {
  Reactions({
      this.likes, 
      this.dislikes,});

  Reactions.fromJson(dynamic json) {
    likes = json['likes'];
    dislikes = json['dislikes'];
  }
  num? likes;
  num? dislikes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['likes'] = likes;
    map['dislikes'] = dislikes;
    return map;
  }

}