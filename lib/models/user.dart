class User {
  String id, username, country_code, phone;
  int dateOfBirth, image_index;
  int last_seen, joining_time, username_last_update_time;
  String notificationToken;
  String about;
  String authType;
  bool? banned;
  double? latitude, longitude;

//<editor-fold desc="Data Methods">

  User({
    required this.id,
    required this.username,
    required this.country_code,
    required this.phone,
    required this.dateOfBirth,
    required this.image_index,
    required this.last_seen,
    required this.joining_time,
    required this.username_last_update_time,
    required this.notificationToken,
    required this.about,
    required this.authType,
    this.banned,
    this.latitude,
    this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          country_code == other.country_code &&
          phone == other.phone &&
          dateOfBirth == other.dateOfBirth &&
          image_index == other.image_index &&
          last_seen == other.last_seen &&
          joining_time == other.joining_time &&
          username_last_update_time == other.username_last_update_time &&
          notificationToken == other.notificationToken &&
          about == other.about &&
          authType == other.authType &&
          banned == other.banned &&
          latitude == other.latitude &&
          longitude == other.longitude);

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      country_code.hashCode ^
      phone.hashCode ^
      dateOfBirth.hashCode ^
      image_index.hashCode ^
      last_seen.hashCode ^
      joining_time.hashCode ^
      username_last_update_time.hashCode ^
      notificationToken.hashCode ^
      about.hashCode ^
      authType.hashCode ^
      banned.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' id: $id,' +
        ' username: $username,' +
        ' country_code: $country_code,' +
        ' phone: $phone,' +
        ' dateOfBirth: $dateOfBirth,' +
        ' image_index: $image_index,' +
        ' last_seen: $last_seen,' +
        ' joining_time: $joining_time,' +
        ' username_last_update_time: $username_last_update_time,' +
        ' notificationToken: $notificationToken,' +
        ' about: $about,' +
        ' authType: $authType,' +
        ' banned: $banned,' +
        ' latitude: $latitude,' +
        ' longitude: $longitude,' +
        '}';
  }

  User copyWith({
    String? id,
    String? username,
    String? country_code,
    String? phone,
    int? dateOfBirth,
    int? image_index,
    int? last_seen,
    int? joining_time,
    int? username_last_update_time,
    String? notificationToken,
    String? about,
    String? authType,
    bool? banned,
    double? latitude,
    double? longitude,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      country_code: country_code ?? this.country_code,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      image_index: image_index ?? this.image_index,
      last_seen: last_seen ?? this.last_seen,
      joining_time: joining_time ?? this.joining_time,
      username_last_update_time: username_last_update_time ?? this.username_last_update_time,
      notificationToken: notificationToken ?? this.notificationToken,
      about: about ?? this.about,
      authType: authType ?? this.authType,
      banned: banned ?? this.banned,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'username': this.username,
      'country_code': this.country_code,
      'phone': this.phone,
      'dateOfBirth': this.dateOfBirth,
      'image_index': this.image_index,
      'last_seen': this.last_seen,
      'joining_time': this.joining_time,
      'username_last_update_time': this.username_last_update_time,
      'notificationToken': this.notificationToken,
      'about': this.about,
      'authType': this.authType,
      'banned': this.banned,
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      country_code: map['country_code'] as String,
      phone: map['phone'] as String,
      dateOfBirth: map['dateOfBirth'] as int,
      image_index: map['image_index'] as int,
      last_seen: map['last_seen'] as int,
      joining_time: map['joining_time'] as int,
      notificationToken: map['notificationToken'] as String,
      about: map['about'] as String,
      authType: map['authType'] as String,
      banned: map['banned'] as bool?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      username_last_update_time: map['username_last_update_time'] as int? ?? 0,
    );
  }

//</editor-fold>
}