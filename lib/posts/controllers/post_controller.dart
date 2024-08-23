import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'package:todo_app/Model/post_model.dart';
import 'package:todo_app/controllers/network_controller.dart';

class PostController extends GetxController {
  final NetworkController _networkController = Get.find<NetworkController>();

  RxList<Posts> posts = <Posts>[].obs;
  RxList<num> favoritePosts = <num>[].obs;
  RxBool isLoading = false.obs;
  RxBool paginationLoader = false.obs;

  int _limit = 10;
  RxBool hasMoreData = true.obs;

  void addToFavorites(num postId) {
    favoritePosts.add(postId);
  }

  void removeFromFavorites(num postId) {
    favoritePosts.remove(postId);
  }

  void deleteAllPosts() {
    posts.clear();
  }

  Future<void> getPosts() async {
    try {
      final response = await _networkController.getPost(limit: _limit);
      if (response != null) {
        if ((response.posts ?? []).isEmpty) {
          hasMoreData.value = false;
          return;
        } else {
          posts.value = response.posts!;
          _limit += 10;
        }
      } else {
        Toast.show('Something went wrong');
      }
    } on Exception catch (e) {
      isLoading.value = false;

      Toast.show(e.toString());
    }
  }
}
