// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:brasiltoon/src/models/gallery_models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_models.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'personImage')
  GalleryModel? userphoto;
  @JsonKey(name: 'fullname')
  String? name;
  String? email;
  String? phone;
  // String? cpf;
  String? password;
  String? id;
  String? token;

  UserModel(
      {this.userphoto,
      this.phone,
      //this.cpf,
      this.email,
      this.name,
      this.password,
      this.id,
      this.token});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel(userphoto: $userphoto, name: $name, email: $email, phone: $phone, password: $password, id: $id, token: $token)';
  }
}
