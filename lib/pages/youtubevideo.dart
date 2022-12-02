// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:santhe/core/loggers.dart';
import 'package:santhe/pages/home_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoGuide extends StatefulWidget {
  const YoutubeVideoGuide({
    Key? key,
  }) : super(key: key);

  @override
  State<YoutubeVideoGuide> createState() => _YoutubeVideoGuideState();
}

class _YoutubeVideoGuideState extends State<YoutubeVideoGuide> with LogMixin {
  late YoutubePlayerController _youtubecontroller;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _showVideo = false;
  bool _isPlayerReady = false;

  void listener() {
    // if (_isPlayerReady && mounted && !_youtubecontroller.value.isFullScreen) {
    //   setState(() {
    //     _playerState = _youtubecontroller.value.playerState;
    //     _videoMetaData = _youtubecontroller.metadata;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _youtubecontroller = YoutubePlayerController(
      initialVideoId: 'XKMKWENGENE',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  @override
  void dispose() {
    _youtubecontroller.dispose();
    screenOrientation();
    warningLog('disposed');
    super.dispose();
  }

  screenOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _youtubecontroller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Santhe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    child: const HomePage(),
                    type: PageTransitionType.leftToRight,
                  ),
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: player,
        );
      },
    );
  }
}
