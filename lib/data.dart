
class Album {
  String url;
  String id;
  String title;
  String addTime;

  Album(this.url, this.id, this.title, this.addTime);
  factory Album.create(Map<String, dynamic> map) {
    String time = map['addtime'].toString().substring(0,10);
    int month = int.parse(time.substring(5,7));
    int day = int.parse(time.substring(8));
    return Album(
      map['url'],
      map['id'],
      map['title'],
      "$day/$month",
    );
  }

  @override
  String toString() {
    return 'Album{url: $url, id: $id, title: $title, addTime: $addTime}';
  }


}

class Picture {
  String url;
  String author;
  String title;
  String content;


  Picture(this.url, this.author, this.title, this.content);

  factory Picture.create(Map<String, dynamic> map) {
    return Picture(
      map['url'],
      map['author'],
      map['title'],
      map['content'],
    );
  }

  @override
  String toString() {
    return 'Picture{url: $url, author: $author, title: $title, content: $content}';
  }


}
