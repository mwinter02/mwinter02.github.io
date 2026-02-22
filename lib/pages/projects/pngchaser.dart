import 'package:flutter/material.dart';
import 'package:website/router.dart';

import '../../widgets/video_player.dart';

class PngChaserPage extends StatelessWidget {
  const PngChaserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PNG Chaser'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            SimpleWebVideoPlayer(videoPath: 'pngchaser_demo.mp4'),

            ElevatedButton(onPressed: () => context.go(RouteNames.home), child: Text('To home.')),
            ElevatedButton(onPressed: () => context.go(RouteNames.projects), child: Text('To projects.')),
            ElevatedButton(onPressed: () => context.go(RouteNames.zombies), child: Text('To zombies.')),
          ],
        ),
      ),
    );
  }
}
