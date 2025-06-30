import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:user_details/data/db_provider.dart';
import 'package:user_details/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepo {
  final DBHelper dbHelper = DBHelper();
  static const endpoint = 'https://jsonplaceholder.typicode.com/users';
  Future<List<User>> fetchUser() async {
    try {
      final uri = Uri.parse(endpoint);
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'Mozilla/5.0(Flutter; dart.io)',
          'Accpet': 'application/json',
        },
      );
      log("status is: ${response.statusCode}");
      log("Body is: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final users = data.map((e) => User.fromJson(e)).toList();
        await dbHelper.insertUsers(users);
        return users;
      } else {
        throw HttpException(
          "CloudFare/WAF blocked request (status ${response.statusCode})",
          uri: uri,
        );
      }
    } on SocketException {
      throw const HttpException("No internet connection");
    } on FormatException {
      throw const FormatException("Bad JSON format");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> fetchUsersFromDb() async {
    return await dbHelper.getUsers();
  }
}
