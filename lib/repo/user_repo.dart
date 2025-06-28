import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:user_details/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepo {
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
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
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
}
