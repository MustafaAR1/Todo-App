import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:todo_app/Model/post_model.dart';

class NetworkController extends GetxController {
  final dio = Dio();

  Future<PostModel?> getPost({int limit = 10, int skip = 10}) async {
    final response =
        await dio.get('https://dummyjson.com/posts?limit=$limit&skip=$skip');
    if (response.statusCode == 200) {
      return PostModel.fromJson(response.data);
    } else {
      return null;
    }
  }
}
