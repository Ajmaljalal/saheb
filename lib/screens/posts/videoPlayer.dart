import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../languages/index.dart';

class VideoHolder extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  VideoHolder({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _VideoHolderState createState() => _VideoHolderState();
}

class _VideoHolderState extends State<VideoHolder> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      showControlsOnInitialize: false,
      errorBuilder: (context, errorMessage) {
        final appLanguage = getLanguages(context);
        errorMessage = appLanguage['playingVideoError'];
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
