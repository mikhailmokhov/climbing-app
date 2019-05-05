///
/// Describes user
class User {
  final String uuid;
  String name;
  String email;
  String pictureId;

  User(this.uuid, this.name, this.email, [this.pictureId]);

  User.fromJson(Map<String, dynamic> json)
      : this.uuid = json["uuid"],
        this.name = json["name"],
        this.email = json["email"],
        this.pictureId = json["pictureId"];

  Map<String, dynamic> toJson() {
    return {
      'uuid': this.uuid,
      'name': this.name,
      'email': this.email,
      'pictureId': this.pictureId
    };
  }

  String getPictureUrl(){
    return 'http://mokhov.ca/honnold.png';
  }
}
