import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/domain/token.dart';
import 'package:http/http.dart' as http;
import '../../domain/credential.dart';
import '../api/auth_api_contract.dart';
import './mapper.dart';

class AuthApi implements IAuthApi {
  final http.Client _client;

  String baseUrl;

  AuthApi(this.baseUrl, this._client);
  @override
  Future<Result<String>> signIn(Credential credential) async {
    var endpoint = baseUrl + '/users/login';
    return await _postCredential(endpoint, credential);
  }

  @override
  Future<Result<String>> signUp(Credential credential) async {
    var endpoint = baseUrl + '/users/register';
    return await _postCredential(endpoint, credential);
  }

  Future<Result<String>> _postCredential(
      String endpoint, Credential credential) async {
    var response = await _client.post(endpoint,
        body: jsonEncode(Mapper.toJson(credential)),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        });
    if (response.statusCode != 200) return Result.error('Server Error');
    var json = jsonDecode(response.body);

    return json["data"]["token"] != null
        ? Result.value(json["data"]["token"])
        : Result.error(json["message"]);
  }

  @override
  Future<Result<bool>> signOut(Token token) async {
    var url = baseUrl + '/users/logout';
    var headers = {
      "Content-Type": "application/json",
      "Authorization": token.value
    };

    var response = await _client.post(url, headers: headers);
    if (response.statusCode != 200) return Result.value(false);
    return Result.value(true);
  }
}
