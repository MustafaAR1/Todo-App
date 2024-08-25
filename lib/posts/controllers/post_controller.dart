import 'package:get/get.dart';
import 'package:toast/toast.dart';
import 'package:todo_app/Model/post_model.dart';
import 'package:todo_app/controllers/database_controller.dart';
import 'package:todo_app/controllers/network_controller.dart';

class PostController extends GetxController {
  final NetworkController _networkController = Get.find<NetworkController>();
  final DatabaseController _databaseController = Get.find<DatabaseController>();

  RxList<Posts> posts = <Posts>[].obs;
  RxList<num> favoritePosts = <num>[].obs;
  RxBool isLoading = false.obs;
  RxBool paginationLoader = false.obs;

  int _limit = 10;
  RxBool hasMoreData = true.obs;

  void addToFavorites(num postId) {
    favoritePosts.add(postId);
    _databaseController.favoritePost(postId, true);
  }

  void removeFromFavorites(num postId) {
    favoritePosts.remove(postId);
    _databaseController.favoritePost(postId, false);
  }

  void removePost(int index, num postId) {
    posts.removeAt(index);
    _databaseController.removePostFromDB(postId);
  }

  void deleteAllPosts() {
    posts.clear();
    _databaseController.removeAllPosts();
  }

  Future<void> getPosts() async {
    try {
      // if (await _networkController.checkInternetConnection()) {
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
      // } else {
      //   final localPosts = await _databaseController.getPostsFromDB();
      //   posts.value = localPosts;
      //   hasMoreData.value = false;
      // }
    } on Exception catch (e) {
      isLoading.value = false;
      Toast.show(e.toString());
    }
  }}
