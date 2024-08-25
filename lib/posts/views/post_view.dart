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
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text('Your Daily Posts',style: TextStyle(color: Colors.white),), actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined,color: Colors.white,),
            onPressed: () {
              _addPostDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,color: Colors.white,),
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
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  post.title!,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500),
                                ),     Obx(() => IconButton(
              color: _postController.favoritePosts.contains(post.id)
                  ? Colors.red
                  : Colors.grey,
              icon: const Icon(Icons.favorite_outline),
              onPressed: () {
                if (!_postController.favoritePosts.contains(post.id!)) {
                  _postController.addToFavorites(post.id!);
                } else {
                  _postController.removeFromFavorites(post.id!);
                }
              },
            )),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             if(post.body!=null) Text(post.body!),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: post.tags
                                        ?.map((tag) => Chip(
                                              label: Text(tag,
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              backgroundColor:
                                                   Colors.blueAccent,
                                              labelStyle: const TextStyle(
                                                  color: Colors.white),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ))
                                        .toList() ??
                                    [],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Total Views: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        post.views.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  _bottomWidget(index, post),
                                ],
                              ),
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
                        ),
                      );
                    } else if (_postController.paginationLoader.value) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 32, top: 32),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
      ),
    );
  }

  Widget _bottomWidget(int index, Posts post) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _postController.removePost(index,post.id!);
          },
        ),
   
      ],
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
