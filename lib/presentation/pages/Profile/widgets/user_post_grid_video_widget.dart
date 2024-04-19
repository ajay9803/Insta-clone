import 'package:flutter/material.dart';
import 'package:instaclone/models/user_post.dart';
import 'package:video_player/video_player.dart';

class UserPostGridViewVideoWidget extends StatefulWidget {
  final UserPostModel post;
  const UserPostGridViewVideoWidget({super.key, required this.post});

  @override
  State<UserPostGridViewVideoWidget> createState() =>
      _UserPostGridViewVideoWidgetState();
}

class _UserPostGridViewVideoWidgetState
    extends State<UserPostGridViewVideoWidget> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.post.medias[0].url,
      ),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return VideoPlayer(_controller);
          // return LayoutBuilder(builder: (context, cts) {
          //   return SizedBox.expand(
          //     child: FittedBox(
          //       fit: BoxFit.cover,
          //       child: SizedBox(
          //         width: cts.maxWidth,
          //         height: cts.maxWidth,
          //         child: VideoPlayer(_controller),
          //       ),
          //     ),
          //   );
          // });
        } else if (snapshot.hasError) {
          return Container(
            color: Colors.grey,
            child: const Center(
              child: Icon(
                Icons.error,
              ),
            ),
          );
        } else {
          return Container(
            color: Colors.grey,
          );
        }
      },
    );
  }
}
