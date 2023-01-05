class TroProperties {
  late ApiProperties apiProperties;
  late LoggerProperties loggerProperties;
}

class ApiProperties {
  String? baseUrl;
  int? connectTimeout;
  int? receiveTimeout;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  ApiProperties({
    this.baseUrl,
    this.connectTimeout,
    this.receiveTimeout,
  });

  ApiProperties copyWith({
    String? baseUrl,
    int? connectTimeout,
    int? receiveTimeout,
  }) {
    return ApiProperties(
      baseUrl: baseUrl ?? this.baseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
    );
  }

  @override
  String toString() {
    return 'ApiProperties{baseUrl: $baseUrl, connectTimeout: $connectTimeout, receiveTimeout: $receiveTimeout}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApiProperties &&
          runtimeType == other.runtimeType &&
          baseUrl == other.baseUrl &&
          connectTimeout == other.connectTimeout &&
          receiveTimeout == other.receiveTimeout);

  @override
  int get hashCode =>
      baseUrl.hashCode ^ connectTimeout.hashCode ^ receiveTimeout.hashCode;

  factory ApiProperties.fromMap(Map map) {
    return ApiProperties(
      baseUrl: map['baseUrl'] as String?,
      connectTimeout: map['connectTimeout'] as int?,
      receiveTimeout: map['receiveTimeout'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'baseUrl': baseUrl,
      'connectTimeout': connectTimeout,
      'receiveTimeout': receiveTimeout,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class LoggerProperties {
  String level = 'info';

//<editor-fold desc="Data Methods">

  LoggerProperties({
    required this.level,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoggerProperties &&
          runtimeType == other.runtimeType &&
          level == other.level);

  @override
  int get hashCode => level.hashCode;

  @override
  String toString() {
    return 'LoggerProperties{' + ' level: $level,' + '}';
  }

  LoggerProperties copyWith({
    String? level,
  }) {
    return LoggerProperties(
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'level': this.level,
    };
  }

  factory LoggerProperties.fromMap(Map map) {
    return LoggerProperties(
      level: map['level'] as String,
    );
  }

//</editor-fold>
}
