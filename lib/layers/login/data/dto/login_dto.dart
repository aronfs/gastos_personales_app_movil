import 'dart:convert';

import 'package:gastos_personales/layers/login/domain/entity/login.dart';



class LoginDto extends Login{
  LoginDto(super.email, super.password);

  factory LoginDto.fromRawJson(String str) => 
      LoginDto.fromMap(json.decode(str));
  String torawJson() => json.encode(toMap());


  factory LoginDto.fromMap(Map<String, dynamic> json) => 
      LoginDto(
        json["email"], 
        json["password"]);

  Map<String, dynamic> toMap() => {
    "email": email,
    "password": password,
  };



}