import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class Entry {
  int id;
  int categoryId;
  int feedId;
  int publishedAt;
  int reactionHappyCount;
  int reactionSurpriseCount;
  int reactionSadCount;
  int reactionAngryCount;
  int commentCount;
  String title;
  String url;
  String content;
  String picture;
  String cdnPicture;
  String author;

  Entry() {
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  bool get hasPicture => picture != null;
  String get formattedDate => timeago
      .format(DateTime.fromMillisecondsSinceEpoch(publishedAt), locale: 'id');
  String formattedDateSimple() {
    var date = DateTime.fromMillisecondsSinceEpoch(publishedAt);
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  String getCategoryName(Map<int, String> categories) {
    var title = categories[categoryId];
    return title;
  }

  Entry setCloudinaryPicture(String cloudinaryFetchUrl) {
    if (this.picture == null ||
        this.picture == "" ||
        cloudinaryFetchUrl == "") {
      return this;
    }
    this.cdnPicture = "$cloudinaryFetchUrl${this.picture}";
    return this;
  }

  static Entry fromJson(dynamic json) {
    var e = new Entry();
    e.id = json['id'];
    e.title = json['title'];
    e.url = json['url'];
    e.content = json['content'];
    e.publishedAt = json["published_at"];
    e.feedId = json['feed_id'];
    e.categoryId = json['category_id'];
    e.reactionHappyCount = json['reaction_happy_count'];
    e.reactionSurpriseCount = json['reaction_surprise_count'];
    e.reactionSadCount = json['reaction_sad_count'];
    e.reactionAngryCount = json['reaction_angry_count'];
    e.commentCount = json['comment_count'];
    if (json['author'] != null) e.author = json['author'];
    if (json['enclosures'] != null) e.picture = json['enclosures'][0]['url'];
    return e;
  }

  static Entry fromBookmarkEntry(BookmarkEntry bookmark) {
    var e = new Entry();
    e.id = bookmark.entryId;
    e.title = bookmark.title;
    e.publishedAt = bookmark.publishedAt;
    e.feedId = bookmark.feedId;
    e.categoryId = bookmark.categoryId;
    e.picture = bookmark.picture;
    return e;
  }

  static List<Entry> emptyList() {
    return List<Entry>();
  }
}

class BookmarkEntry {
  int entryId;
  int feedId;
  int categoryId;
  int publishedAt;
  DateTime bookmarkedAt;
  String title;
  String url;
  String picture;
  String cdnPicture;

  bool get hasPicture => picture != null;
  String get formattedDate => timeago
      .format(DateTime.fromMillisecondsSinceEpoch(publishedAt), locale: 'id');

  String getCategoryName(Map<int, String> categories) {
    var title = categories[categoryId];
    return title;
  }

  BookmarkEntry setCloudinaryPicture(String cloudinaryFetchUrl) {
    if (this.picture == null ||
        this.picture == "" ||
        cloudinaryFetchUrl == "") {
      return this;
    }
    this.cdnPicture = "$cloudinaryFetchUrl${this.picture}";
    return this;
  }

  static BookmarkEntry fromDocument(DocumentSnapshot doc) {
    final data = doc.data;
    var be = new BookmarkEntry();
    be.entryId = data['entry_id'];
    be.title = data['title'];
    be.picture = data['picture'];
    be.feedId = data['feed_id'];
    be.categoryId = data['category_id'];
    be.publishedAt = data["published_at"];

    if (data["bookmarked_at"] == null) {
      be.bookmarkedAt = DateTime.now();
    } else {
      // Ios and Android will not receive same type.
      // Ios receive the timestamps as TimeStamp and Android receive it as DateTime already.
      be.bookmarkedAt = data["bookmarked_at"] is DateTime
          ? data["bookmarked_at"]
          : data["bookmarked_at"].toDate();
    }
    return be;
  }
}
