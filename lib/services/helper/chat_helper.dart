import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_finder_app/model/request/Chat/create_chat.dart';
import 'package:job_finder_app/model/response/Chat/get_chat.dart';
import 'package:job_finder_app/model/response/Chat/initial_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class Chathelper{
  // Apply for a job
  static Future<List<dynamic>> apply(CreateChat model)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");

    // String? userId = pref.getString('userId');

    http.Response? response;
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "x-auth-token": '$token'  // this is x-auth-token same as backend req.header("x-auth-token");
    };
    try{

      response = await http.post(
        Uri.parse('${Config.apiUrl}${Config.chatsUrl}'),
        headers: requestHeaders,
        body: jsonEncode({
          "userId": model.userId
        })  // be careful to use jsonEncode
      )
      ;
    }catch(e)
    {
      print('Create Chat api call error: $e');
    }

    if(response!.statusCode == 200)
    {
      var chatId = initialChatFromJson(response.body).id;
      return [true, chatId];
    }
    else{
      return [false];
    }

  }

  // Get Conversations
  static Future<List<GetChats>> getConversations()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");

    // String? userId = pref.getString('userId');

    http.Response? response;
    Map<String, String> requestHeaders = {
      "Content-Type": "application/json",
      "x-auth-token": '$token'  // this is x-auth-token same as backend req.header("x-auth-token");
    };
    try{
      response = await http.get(
          Uri.parse('${Config.apiUrl}${Config.chatsUrl}'),
          headers: requestHeaders,
      )
      ;
    }catch(e)
    {
      print('Get Conversation Add api call error: $e');
    }

    if(response!.statusCode == 200)
    {
      // print(jsonDecode(response.body)); // all time see response json structure and name same as model
      // i get error response is isGroupChat but i use isGroup in model
      var chats = getChatsFromJson(response.body);
      return chats;
    }
    else{
      throw Exception("Couldn't load chats");
    }

  }
}