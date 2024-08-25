import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/Model/post_model.dart';

class NetworkController extends GetxController {
  final dio = Dio();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<bool> checkInternetConnection() async {
    try {
      final response = await dio.get('https://www.google.com');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

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
