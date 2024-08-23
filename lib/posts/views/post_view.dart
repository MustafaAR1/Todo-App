import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/Model/post_model.dart';
import 'package:todo_app/posts/controllers/post_controller.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final PostController _postController = Get.find<PostController>();
  final ScrollController _scrollController = ScrollController();
  final int _postsPerPage = 10;

  final TextEditingController _postTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _postController.isLoading.value = true;
      await _postController.getPosts();
      _postController.isLoading.value = false;
    });
  }

  Future<void> _loadMorePosts() async {
    _postController.paginationLoader.value = true;
    await _postController.getPosts();
    _postController.paginationLoader.value = false;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('Posts'), actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () {
              _addPostDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _postController.deleteAllPosts();
            },
          ),
        ]),
        body: _postController.isLoading.value == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollEndNotification &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    _loadMorePosts();
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: _postController.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _postController.posts.length) {
                      Posts post = _postController.posts[index];
                      return ListTile(
                        title: Text(post.title!),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _postController.posts.removeAt(index);
                              },
                            ),
                            Obx(() => IconButton(
                                  color: _postController.favoritePosts
                                          .contains(post.id)
                                      ? Colors.red
                                      : Colors.grey,
                                  icon: const Icon(Icons.favorite_outline),
                                  onPressed: () {
                                    if (!_postController.favoritePosts
                                        .contains(post.id!)) {
                                      _postController.addToFavorites(post.id!);
                                    } else {
                                      _postController
                                          .removeFromFavorites(post.id!);
                                    }
                                  },
                                )),
                          ],
                        ),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => PostDetailView(post: post),
                          //   ),
                          // );
                        },
                      );
                    } else if (_postController.paginationLoader.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
      ),
    );
  }

  Future<dynamic> _addPostDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _postTextController,
                decoration: const InputDecoration(hintText: 'Your Post'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _postController.posts.add(Posts(
                    title: _postTextController.text,
                    id: Random().nextInt(1000000)));

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
