import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

const String _baseUrl =
    'https://raw.githubusercontent.com/mwinter02/mwinter02.github.io/main/assets/video/';

/// Path from assets/video/ to the video file, e.g. `zombies_demo.mp4`
String getVideoUrl(String videoPath) {
  return '$_baseUrl$videoPath';
}

class SimpleWebVideoPlayer extends StatefulWidget {
  final String videoPath;

  const SimpleWebVideoPlayer({required this.videoPath, super.key});

  @override
  State<SimpleWebVideoPlayer> createState() => _SimpleWebVideoPlayerState();
}

class _SimpleWebVideoPlayerState extends State<SimpleWebVideoPlayer> {
  late final Player _player = Player();
  late final VideoController _controller = VideoController(_player);
  bool _initialized = false;
  bool _error = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    final url = getVideoUrl(widget.videoPath);
    _player
        .open(Media(url))
        .then((_) {
          setState(() {
            _initialized = true;
            _player.pause(); // Start paused
          });
        })
        .catchError((_) {
          setState(() {
            _error = true;
          });
        });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return const Center(child: Text('Failed to load video.'));
    }
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final width = _player.state.width;
    final height = _player.state.height;
    final aspectRatio = (width != null && height != null && height > 0)
        ? (width / height)
        : 16 / 9;

    _player.stream.playing.listen((bool playing) {
      if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          _isPlaying = playing;
        });
      }
    });
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          Video(controller: _controller, controls: MaterialVideoControls),
          if (!_isPlaying)
            Center(
              child: IconButton(
                color: Colors.white,
                onPressed: () => _player.play(),
                icon: const Icon(
                  Icons.play_arrow,
                  size: 64,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
