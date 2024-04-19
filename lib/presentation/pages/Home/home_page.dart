import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instaclone/presentation/pages/Home/widgets/home_page_appbar.dart';
import 'package:instaclone/presentation/pages/Home/widgets/user_stories.dart';
import 'package:instaclone/providers/user_posts_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../UserPosts/widgets/user_post_widget.dart';

class HomePage extends StatefulWidget {
  final Function navigateToChatsPage;
  const HomePage({Key? key, required this.navigateToChatsPage})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  late RefreshController _refreshController;
  int postLimit = 4;

  final ValueNotifier _isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier _hasErrorNotifier = ValueNotifier(null);

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    _fetchLatestPosts();
    super.initState();
  }

  Future<void> _onRefresh() async {
    Provider.of<UserPostsProvider>(context, listen: false)
        .fetchLatestPosts(postLimit);

    // Reset the post limit when refreshing
    postLimit = 4;
    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    // Increase the post limit by 2 when loading more posts
    postLimit += 2;
    Provider.of<UserPostsProvider>(context, listen: false)
        .fetchLatestPosts(postLimit);
    _refreshController.loadComplete();
  }

  Future<void> _fetchLatestPosts() async {
    _isLoadingNotifier.value = true;
    await Provider.of<UserPostsProvider>(context, listen: false)
        .fetchLatestPosts(postLimit)
        .then((value) {
      _hasErrorNotifier.value = null;
    }).catchError((e) {
      _hasErrorNotifier.value = e.toString();
    });
    _isLoadingNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope(
      canPop: false,
      // onPopInvoked: (bool didPop) {
      //   if (didPop) {
      //     return;
      //   } else {
      //     Navigator.of(context).pop();
      //   }
      // },
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxScrolled) {
            return [
              SliverAppBar(
                title: const HomePageAppBar(),
                actions: [
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_outline,
                        color: Theme.of(context).errorColor,
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          widget.navigateToChatsPage();
                        },
                        child: Icon(
                          Icons.message_outlined,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],

                floating:
                    true, // App bar floats over content when scrolled down
                snap: true, // App bar snaps into place when scrolled up
              ),
            ];
          },
          physics: const BouncingScrollPhysics(),
          body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            header: CustomHeader(
              builder: (BuildContext context, RefreshStatus? mode) {
                Widget? body;
                if (mode == RefreshStatus.idle) {
                  body = const BlueRefreshIndicator();
                } else if (mode == RefreshStatus.refreshing) {
                  body = const BlueRefreshIndicator();
                } else if (mode == RefreshStatus.failed) {
                  body = const Text("Refresh failed, Try again later");
                } else if (mode == RefreshStatus.completed) {
                  body = const BlueRefreshIndicator();
                }
                return SizedBox(
                  height: 80.0,
                  child: Center(child: body),
                );
              },
            ),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const SizedBox();
                } else if (mode == LoadStatus.loading) {
                  body = const BlueRefreshIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed!");
                } else {
                  body = const SizedBox();
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(
                    child: body,
                  ),
                );
              },
            ),
            child: CustomScrollView(
              slivers: [
                // SliverAppBar with floating behavior
                // SliverAppBar(
                //   title: const HomePageAppBar(),
                //   actions: [
                //     Row(
                //       children: [
                //         const Icon(Icons.favorite_outline),
                //         const SizedBox(width: 20),
                //         GestureDetector(
                //           onTap: () {
                //             widget.navigateToChatsPage();
                //           },
                //           child: const Icon(Icons.message_outlined),
                //         ),
                //         const SizedBox(width: 10),
                //       ],
                //     ),
                //   ],
                //   floating: true, // App bar floats over content when scrolled down
                //   snap: true, // App bar snaps into place when scrolled up
                //   elevation: 0, // No shadow
                // ),

                // User stories
                const SliverToBoxAdapter(
                  child: TheStories(),
                ),

                // Divider
                const SliverToBoxAdapter(
                  child: Divider(
                    color: Colors.white,
                  ),
                ),

                // Latest posts
                ValueListenableBuilder(
                    valueListenable: _isLoadingNotifier,
                    builder: (context, value, child) {
                      if (value == true) {
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: const Center(
                              child: BlueRefreshIndicator(),
                            ),
                          ),
                        );
                      } else {
                        return ValueListenableBuilder(
                            valueListenable: _hasErrorNotifier,
                            builder: (context, value, child) {
                              if (value != null) {
                                return SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: 400,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            _hasErrorNotifier.value,
                                          ),
                                          TextButton(
                                            onPressed: _onRefresh,
                                            child: const Text(
                                              'Refresh',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Consumer<UserPostsProvider>(
                                  builder: (context, postData, child) {
                                    if (postData.latestPosts.isEmpty) {
                                      return SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: 400,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'No posts to view.',
                                                ),
                                                TextButton(
                                                  onPressed: _onRefresh,
                                                  child: const Text(
                                                    'Refresh',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            final userPost =
                                                postData.latestPosts[index];
                                            return ChangeNotifierProvider.value(
                                              value: userPost,
                                              child: const UserPostWidget(),
                                            );
                                          },
                                          childCount:
                                              postData.latestPosts.length,
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            });
                      }
                    }),
                // }
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlueRefreshIndicator extends StatelessWidget {
  const BlueRefreshIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Colors.blueAccent,
      strokeWidth: 1,
    );
  }
}
