// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userphoto: json['personImage'] == null
          ? null
          : GalleryModel.fromJson(json['personImage'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      name: json['fullname'] as String?,
      password: json['password'] as String?,
      id: json['id'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'personImage': instance.userphoto,
      'fullname': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'id': instance.id,
      'token': instance.token,
    };
