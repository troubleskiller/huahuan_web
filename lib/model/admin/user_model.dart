class User {
  User({
    this.userName,
    this.passWord,
  });

  User.fromJson(dynamic json) {
    userName = json['userName'];
    passWord = json['passWord'];
  }
  String? userName;
  String? passWord;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userName'] = userName;
    map['passWord'] = passWord;
    return map;
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'passWord': passWord,
    };
  }

  @override
  String toString() {
    return 'User{name: $userName, passWord: $passWord}';
  }
}
