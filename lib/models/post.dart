class Post {
  String id, user_id, media_url, description, thumbnail;
  int timestamp;
  int video_sec;
  String state_id, city_id;

//<editor-fold desc="Data Methods">

  Post({
    required this.id,
    required this.user_id,
    required this.media_url,
    required this.description,
    required this.thumbnail,
    required this.timestamp,
    required this.video_sec,
    required this.state_id,
    required this.city_id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Post &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          user_id == other.user_id &&
          media_url == other.media_url &&
          description == other.description &&
          thumbnail == other.thumbnail &&
          timestamp == other.timestamp &&
          video_sec == other.video_sec &&
          state_id == other.state_id &&
          city_id == other.city_id);

  @override
  int get hashCode =>
      id.hashCode ^
      user_id.hashCode ^
      media_url.hashCode ^
      description.hashCode ^
      thumbnail.hashCode ^
      timestamp.hashCode ^
      video_sec.hashCode ^
      state_id.hashCode ^
      city_id.hashCode;

  @override
  String toString() {
    return 'Post{' +
        ' id: $id,' +
        ' user_id: $user_id,' +
        ' media_url: $media_url,' +
        ' description: $description,' +
        ' thumbnail: $thumbnail,' +
        ' timestamp: $timestamp,' +
        ' video_sec: $video_sec,' +
        ' state_id: $state_id,' +
        ' city_id: $city_id,' +
        '}';
  }

  Post copyWith({
    String? id,
    String? user_id,
    String? media_url,
    String? description,
    String? thumbnail,
    int? timestamp,
    int? video_sec,
    String? state_id,
    String? city_id,
  }) {
    return Post(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      media_url: media_url ?? this.media_url,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      timestamp: timestamp ?? this.timestamp,
      video_sec: video_sec ?? this.video_sec,
      state_id: state_id ?? this.state_id,
      city_id: city_id ?? this.city_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'user_id': this.user_id,
      'media_url': this.media_url,
      'description': this.description,
      'thumbnail': this.thumbnail,
      'timestamp': this.timestamp,
      'video_sec': this.video_sec,
      'state_id': this.state_id,
      'city_id': this.city_id,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      user_id: map['user_id'] as String,
      media_url: map['media_url'] as String,
      description: map['description'] as String,
      thumbnail: map['thumbnail'] as String,
      timestamp: map['timestamp'] as int,
      video_sec: map['video_sec'] as int,
      state_id: map['state_id'] as String? ?? "",
      city_id: map['city_id'] as String? ?? "",
    );
  }

//</editor-fold>
}