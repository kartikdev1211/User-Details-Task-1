import 'dart:convert';
import 'dart:developer';
import 'package:user_details/models/user_model.dart';
import 'package:http/http.dart'as http;
class UserRepo{
  Future<List<User>> fetchUser()async{
    final url="https://jsonplaceholder.typicode.com/users";
    final response=await http.get(Uri.parse(url));
    log("Response is: ${response.body}");
    if(response.statusCode==200){
      final List user=jsonDecode(response.body);
      log("Users are: $user");
      return user.map((j)=>User.fromJson(j)).toList();
    }else{
      throw Exception("API Failed");
    }
  }
}