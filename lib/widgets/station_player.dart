import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class StationPlayer extends StatelessWidget {
  final YoutubePlayerController controller;

  const StationPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Fill the screen
    return YoutubePlayer(
      controller: controller,
      aspectRatio: 16 / 9,
    );
  }
}
