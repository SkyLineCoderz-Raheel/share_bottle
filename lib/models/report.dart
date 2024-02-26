class Report {
  String id;
  String? reportContentType = "post";
  String reporter_id, post_id;
  int timestamp;

//<editor-fold desc="Data Methods">

  Report({
    required this.id,
    this.reportContentType,
    required this.reporter_id,
    required this.post_id,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Report &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          reportContentType == other.reportContentType &&
          reporter_id == other.reporter_id &&
          post_id == other.post_id &&
          timestamp == other.timestamp);

  @override
  int get hashCode => id.hashCode ^ reportContentType.hashCode ^ reporter_id.hashCode ^ post_id.hashCode ^ timestamp.hashCode;

  @override
  String toString() {
    return 'Report{' +
        ' id: $id,' +
        ' reportContentType: $reportContentType,' +
        ' reporter_id: $reporter_id,' +
        ' post_id: $post_id,' +
        ' timestamp: $timestamp,' +
        '}';
  }

  Report copyWith({
    String? id,
    String? reportContentType,
    String? reporter_id,
    String? post_id,
    int? timestamp,
  }) {
    return Report(
      id: id ?? this.id,
      reportContentType: reportContentType ?? this.reportContentType,
      reporter_id: reporter_id ?? this.reporter_id,
      post_id: post_id ?? this.post_id,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'reportContentType': this.reportContentType,
      'reporter_id': this.reporter_id,
      'post_id': this.post_id,
      'timestamp': this.timestamp,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as String,
      reportContentType: map['reportContentType'] as String? ?? "",
      reporter_id: map['reporter_id'] as String,
      post_id: map['post_id'] as String,
      timestamp: map['timestamp'] as int,
    );
  }

//</editor-fold>
}