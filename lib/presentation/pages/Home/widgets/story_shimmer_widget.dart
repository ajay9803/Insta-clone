import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:shimmer/shimmer.dart';

class StoryShimmerWidget extends StatelessWidget {
  const StoryShimmerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return const StoryShimmer();
        });
  }
}

class StoryShimmer extends StatelessWidget {
  const StoryShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.black26,
            highlightColor: Colors.white10,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.085,
              width: MediaQuery.of(context).size.height * 0.085,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBoxConstants.sizedboxh5,
          Shimmer.fromColors(
            baseColor: Colors.black26,
            highlightColor: Colors.white10,
            child: Container(
              height: 15,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
